#!/usr/bin/env bun

import { readdirSync, readFileSync, realpathSync, statSync, writeFileSync } from "node:fs"
import { homedir } from "node:os"
import { join } from "node:path"

const skillsRoot = join(homedir(), ".agents", "skills")
const visitedDirectories = new Set<string>()
const visitedSkills = new Set<string>()

function patchSkill(filePath: string) {
  let realPath: string

  try {
    realPath = realpathSync(filePath)
  } catch {
    return
  }

  if (visitedSkills.has(realPath)) return
  visitedSkills.add(realPath)

  const original = readFileSync(realPath, "utf8")
  const lineEnding = original.includes("\r\n") ? "\r\n" : "\n"
  const match = original.match(/^---(?:\r?\n)([\s\S]*?)(?:\r?\n)---([\s\S]*)$/)

  if (!match) return

  const frontmatter = match[1].replaceAll("\r\n", "\n")

  // Only patch skills that are explicitly manual-only for portable clients.
  if (!/^disable-model-invocation:\s*(?:true|"true"|'true')\s*(?:#.*)?$/m.test(frontmatter)) {
    return
  }

  const autoinvokeKey = /^([ \t]*)(["']?opencode\/autoinvoke["']?):[^\r\n]*$/m
  let patchedFrontmatter = frontmatter

  if (autoinvokeKey.test(patchedFrontmatter)) {
    patchedFrontmatter = patchedFrontmatter.replace(
      autoinvokeKey,
      '$1"opencode/autoinvoke": false',
    )
  } else {
    const emptyInlineMetadata = /^metadata:\s*\{\s*\}\s*$/m
    const inlineMetadata = /^metadata:\s*\{([^\r\n]*)\}\s*$/m
    const metadataBlock = /^metadata:\s*(?:#.*)?$/m

    if (emptyInlineMetadata.test(patchedFrontmatter)) {
      patchedFrontmatter = patchedFrontmatter.replace(
        emptyInlineMetadata,
        'metadata:\n  "opencode/autoinvoke": "false"',
      )
    } else if (inlineMetadata.test(patchedFrontmatter)) {
      patchedFrontmatter = patchedFrontmatter.replace(
        inlineMetadata,
        (_line, contents: string) => {
          const separator = contents.trim() ? ", " : ""
          return `metadata: {${contents}${separator}"opencode/autoinvoke": "false"}`
        },
      )
    } else if (metadataBlock.test(patchedFrontmatter)) {
      patchedFrontmatter = patchedFrontmatter.replace(
        metadataBlock,
        (line) => `${line}\n  "opencode/autoinvoke": "false"`,
      )
    } else {
      patchedFrontmatter =
        `${patchedFrontmatter.trimEnd()}\n` +
        `metadata:\n` +
        `  "opencode/autoinvoke": "false"`
    }
  }

  if (patchedFrontmatter === frontmatter) return

  const patched =
    `---${lineEnding}` +
    patchedFrontmatter.replaceAll("\n", lineEnding) +
    `${lineEnding}---${match[2]}`

  writeFileSync(realPath, patched)
  console.log(`patched ${realPath}`)
}

function walk(directory: string) {
  let realDirectory: string

  try {
    realDirectory = realpathSync(directory)
  } catch {
    return
  }

  if (visitedDirectories.has(realDirectory)) return
  visitedDirectories.add(realDirectory)

  for (const entry of readdirSync(directory, { withFileTypes: true })) {
    const entryPath = join(directory, entry.name)

    let stat
    try {
      stat = statSync(entryPath)
    } catch {
      continue
    }

    if (stat.isDirectory()) {
      walk(entryPath)
    } else if (stat.isFile() && entry.name === "SKILL.md") {
      patchSkill(entryPath)
    }
  }
}

walk(skillsRoot)
