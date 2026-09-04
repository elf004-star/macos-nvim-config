# Neovim.app 启动时 LSP 找不到 Homebrew 安装的工具

## 问题

通过自建的 `Neovim.app`（放在 `/Applications` 中）打开 Go 文件时报错：

```
vim/_core/system:324: ENOENT: no such file or directory (cmd): 'go'
```

而从终端启动 `nvim` 一切正常。

## 涉及文件

- `lua/config/options.lua` — PATH 修复写入位置
- `nvim-lspconfig/lsp/gopls.lua:36` — `identify_go_dir` 中调用 `vim.system({"go", ...})` 时失败

## 根因

macOS 的 `.app` 在启动时**不会 source shell 的配置文件**（`~/.zshrc` 等），因此 PATH 中不包含 `/opt/homebrew/bin`。Neovim 内部的 `vim.system({"go", ...})` 找不到 `go` 二进制文件，导致 `nvim-lspconfig` 中 gopls 的 `identify_go_dir` 函数抛 `ENOENT`。

## 修复

在 `lua/config/options.lua` 开头（其他配置之前）补充 PATH：

```lua
if not vim.env.PATH:find("/opt/homebrew/bin", 1, true) then
  vim.env.PATH = "/opt/homebrew/bin:/opt/homebrew/sbin:" .. vim.env.PATH
end
```

## 同类案例：nvm 的 node 缺失（jsonls exit 127）

同一根因的另一只"受害者"。`.app` 不 source `~/.zshrc`，所以 nvm 的 node（`~/.nvm/versions/node/v*/bin`）也不在 PATH 里。依赖 node 的 LSP（jsonls、tsserver 等）启动时，mason 给的二进制经 `#!/usr/bin/env node` 找 node 失败，报：

```
Client jsonls quit with exit code 127 and signal 0.
... "vscode-json-language-server" "stderr" "env: node: No such file or directory"
```

在 `options.lua` 里同样补 PATH（动态解析 nvm 默认版本）：

```lua
local nvm_node = vim.fn.expand("~/.nvm/versions/node")
local nvm_default = vim.fn.expand("~/.nvm/alias/default")
local node_bins = {}
if vim.fn.filereadable(nvm_default) == 1 then
  local version = vim.fn.readfile(nvm_default)[1]
  node_bins = vim.fn.glob(nvm_node .. "/v" .. version .. "*/bin", false, true)
end
if #node_bins == 0 then
  node_bins = vim.fn.glob(nvm_node .. "/v*/bin", false, true)
end
if #node_bins > 0 and not vim.env.PATH:find(node_bins[1], 1, true) then
  vim.env.PATH = node_bins[1] .. ":" .. vim.env.PATH
end
```

排查提示：检查 LSP 客户端是否真正初始化，看 `client.initialized` 字段（不是 `initialize_result`）。可用
`env PATH=/usr/bin:/bin /opt/homebrew/bin/nvim --headless -c "luafile test.lua"` 模拟 `.app` 的受限 PATH 复现。

## 为什么这个值得记录

- 终端启动正常 vs `.app` 启动失败，差异容易被忽略
- 不只是 gopls，所有通过 Homebrew 安装的 LSP server（rust-analyzer、typescript-language-server 等）都受此影响；依赖 node 的 LSP 则受 nvm node 缺失影响
- 该问题在打开 Lua 文件和其他非 Go 文件时不会暴露，只有在触发特定 LSP 时才出现，排查耗时
- `options.lua` 在 LazyVim 的加载顺序中最早（`lazy.setup()` 期间同步加载），在此处修改 PATH 能确保后续所有插件和 LSP 配置都能找到正确的 PATH
