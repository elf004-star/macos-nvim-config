# JSON 格式化：jsonls LSP 不应作为格式化依赖

## 涉及文件

- `lua/plugins/json.lua`
- `lua/plugins/mason.lua`

## 问题

在 `lua/plugins/json.lua` 中配置了 `jsonls` LSP，并在 `mason.lua` 的 `ensure_installed` 中添加了 `"json-lsp"`。但运行 `:LazyFormatInfo` 显示 "No formatter available" — 保存 JSON 文件时不进行格式化。

## 根因

`vscode-json-languageserver`（即 `jsonls`）**不总是注册** `textDocument/formatting` 能力。LazyVim 的 LSP 格式化回退机制依赖 LSP 客户端报告自己支持 `textDocument/formatting` 或 `textDocument/rangeFormatting`。如果 LSP 没有声明该能力，LazyVim 就找不到有效的 formatter。

## 解决

安装 `jq`（轻量级 JSON 命令行处理器，格式化非常可靠）并显式配置 `conform.nvim` 使用它：

1. 通过 Homebrew 安装 `jq`：
   ```bash
   brew install jq
   ```

2. 在 `lua/plugins/json.lua` 中添加 conform.nvim 配置：
   ```lua
   {
     "stevearc/conform.nvim",
     optional = true,
     opts = {
       formatters_by_ft = {
         json = { "jq" },
         jsonc = { "jq" },
       },
     },
   }
   ```

## 为什么这个坑要注意

- LazyVim 优先使用 `conform.nvim` 的 `formatters_by_ft`，只有当没有匹配的 formatter 时才回退到 LSP
- `jsonls` 的格式化支持不是 100% 可靠的 — 它在 VS Code 中工作良好，但在 Neovim 的 LSP 协议集成中表现不一致
- `jq` 是比 LSP 格式化更快的选择，且不需要任何运行时依赖
- 完整的配置应该保留 `jsonls` 用于 **验证和补全**，但使用 `jq` 做 **格式化**
