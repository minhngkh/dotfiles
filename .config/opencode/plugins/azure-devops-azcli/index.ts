import { execFile } from "node:child_process"
import { Plugin } from "@opencode/plugin"

const SERVER_NAME = "azure-devops"
const SERVER_URL = "https://mcp.dev.azure.com/prodbgsw"
const SCOPE = "https://mcp.dev.azure.com/.default"
const REFRESH_EARLY_MS = 5 * 60 * 1000
const RETRY_MS = 60 * 1000

interface AzureTokenResponse {
  accessToken: string
  expires_on: number | string
}

function acquireAzureToken(): Promise<{ token: string; expiresAt: number }> {
  return new Promise((resolve, reject) => {
    execFile(
      "az",
      ["account", "get-access-token", "--scope", SCOPE, "--output", "json"],
      { encoding: "utf8", timeout: 30_000, maxBuffer: 1024 * 1024 },
      (error, stdout, stderr) => {
        if (error) {
          reject(new Error(stderr.trim() || error.message))
          return
        }

        try {
          const response = JSON.parse(stdout) as AzureTokenResponse
          const expiry = Number(response.expires_on)
          if (!response.accessToken || !Number.isFinite(expiry)) {
            throw new Error("Azure CLI returned an incomplete access-token response")
          }
          resolve({ token: response.accessToken, expiresAt: expiry * 1000 })
        } catch (parseError) {
          reject(parseError)
        }
      },
    )
  })
}

function serverConfig(token: string | undefined) {
  return {
    type: "remote" as const,
    url: SERVER_URL,
    oauth: false as const,
    disabled: !token,
    headers: token ? { Authorization: `Bearer ${token}` } : {},
  }
}

function nextRefreshDelay(expiresAt: number): number {
  const untilRefresh = expiresAt - Date.now() - REFRESH_EARLY_MS
  if (untilRefresh > 0) return untilRefresh
  return Math.max(5_000, Math.min(RETRY_MS, expiresAt - Date.now() - 5_000))
}

export default Plugin.define({
  id: "azure-devops.azcli-auth",
  async setup(ctx) {
    let token: string | undefined
    let expiresAt = 0
    let timer: ReturnType<typeof setTimeout> | undefined
    let disposed = false
    let refreshing = false
    let registered = false

    const schedule = (delay: number) => {
      if (disposed) return
      if (timer) clearTimeout(timer)
      timer = setTimeout(() => void refresh(), delay)
      timer.unref?.()
    }

    const refresh = async () => {
      if (disposed || refreshing) return
      refreshing = true
      try {
        const next = await acquireAzureToken()
        const changed = token !== next.token
        const wasUnavailable = !token
        token = next.token
        expiresAt = next.expiresAt

        if (registered && (changed || wasUnavailable)) {
          await ctx.mcp.reload()
        }

        schedule(nextRefreshDelay(expiresAt))
      } catch (error) {
        console.warn(
          `[azure-devops.azcli-auth] Could not obtain a token with Azure CLI: ${error instanceof Error ? error.message : String(error)}. Run az login if needed; retrying later.`,
        )
        schedule(token ? nextRefreshDelay(expiresAt) : RETRY_MS)
      } finally {
        refreshing = false
      }
    }

    try {
      const initial = await acquireAzureToken()
      token = initial.token
      expiresAt = initial.expiresAt
    } catch (error) {
      console.warn(
        `[azure-devops.azcli-auth] Azure CLI is not ready: ${error instanceof Error ? error.message : String(error)}. Run az login; retrying later.`,
      )
    }

    await ctx.mcp.transform((editor) => {
      editor.set(SERVER_NAME, serverConfig(token))
    })
    registered = true

    schedule(token ? nextRefreshDelay(expiresAt) : RETRY_MS)

    return () => {
      disposed = true
      if (timer) clearTimeout(timer)
    }
  },
})
