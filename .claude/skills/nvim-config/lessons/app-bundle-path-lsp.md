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

## 为什么这个值得记录

- 终端启动正常 vs `.app` 启动失败，差异容易被忽略
- 不只是 gopls，所有通过 Homebrew 安装的 LSP server（rust-analyzer、typescript-language-server 等）都受此影响
- 该问题在打开 Lua 文件和其他非 Go 文件时不会暴露，只有在触发特定 LSP 时才出现，排查耗时
- `options.lua` 在 LazyVim 的加载顺序中最早（`lazy.setup()` 期间同步加载），在此处修改 PATH 能确保后续所有插件和 LSP 配置都能找到正确的 PATH
