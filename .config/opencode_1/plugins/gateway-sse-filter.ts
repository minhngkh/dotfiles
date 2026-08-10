import type { Plugin } from "@opencode-ai/plugin"

type FetchLike = (
  input: RequestInfo | URL,
  init?: RequestInit,
) => Promise<Response>

/**
 * Devmate's Anthropic/OpenAI-compatible gateway emits a nonstandard SSE frame:
 *   data: {"type":"meta","data":{"event":"context_usage","tokens":{...}}}
 * OpenCode's @ai-sdk/openai-compatible parser validates every data line against
 * the OpenAI chat-completion chunk shape (choices | error) and fails on this
 * frame, aborting the stream. This plugin wraps the provider's fetch and strips
 * only those frames, keeping all valid chat/usage/[DONE] frames intact.
 */
function isContextUsageFrame(frame: string): boolean {
  const data = frame
    .split(/\r\n|\n|\r/)
    .filter((line) => line.startsWith("data:"))
    .map((line) => line.slice(5).replace(/^ /, ""))
    .join("\n")
    .trim()

  if (!data || data === "[DONE]") return false

  try {
    const value = JSON.parse(data) as {
      type?: string
      data?: { event?: string }
    }
    return value?.type === "meta" && value?.data?.event === "context_usage"
  } catch {
    return false
  }
}

function filterSse(response: Response): Response {
  const contentType = response.headers.get("content-type") ?? ""
  if (!response.body || !contentType.includes("text/event-stream")) {
    return response
  }

  const decoder = new TextDecoder()
  const encoder = new TextEncoder()
  let pending = ""

  const stream = response.body.pipeThrough(
    new TransformStream<Uint8Array, Uint8Array>({
      transform(chunk, controller) {
        pending += decoder.decode(chunk, { stream: true })

        while (true) {
          const match = /(?:\r\n|\r|\n){2}/.exec(pending)
          if (!match || match.index === undefined) return

          const frame = pending.slice(0, match.index)
          const delimiter = match[0]
          pending = pending.slice(match.index + delimiter.length)

          if (!isContextUsageFrame(frame)) {
            controller.enqueue(encoder.encode(frame + delimiter))
          }
        }
      },
      flush(controller) {
        pending += decoder.decode()

        if (pending && !isContextUsageFrame(pending)) {
          controller.enqueue(encoder.encode(pending))
        }
      },
    }),
  )

  const headers = new Headers(response.headers)
  headers.delete("content-length")
  headers.delete("content-encoding")
  headers.delete("transfer-encoding")

  return new Response(stream, {
    status: response.status,
    statusText: response.statusText,
    headers,
  })
}

export const GatewaySseFilter: Plugin = async () => ({
  config: async (config) => {
    const provider = config.provider?.["devmate"]
    if (!provider) return

    provider.options ??= {}
    const options = provider.options as Record<string, unknown>
    const previous = options.fetch as FetchLike | undefined

    options.includeUsage = false
    options.fetch = async (input, init) => {
      const response = await (
        previous ??
        ((url, requestInit) => globalThis.fetch(url, requestInit))
      )(input, init)

      return filterSse(response)
    }
  },
})
