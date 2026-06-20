---
name: nvim-config
description: Manage this LazyVim-based Neovim configuration — understand architecture, apply changes, and document non-trivial pitfalls and successful patterns for future reference.
---

# Neovim Configuration Management

This skill helps manage the LazyVim-based Neovim configuration at `/Users/abc/.config/nvim`. It covers project architecture, common tasks, and documents valuable lessons learned that aren't obvious from the code or LazyVim documentation.

## Architecture TL;DR

```
init.lua → lua/config/lazy.lua (boot lazy.nvim)
              ├── loads lazy.nvim
              ├── { "LazyVim/LazyVim", import = "lazyvim.plugins" }  → LazyVim defaults
              └── { import = "plugins" }                             → lua/plugins/*.lua

LazyVim加载用户配置的时机：
  lua/config/options.lua  → eager (during lazy.setup())
  lua/config/keymaps.lua  → User VeryLazy (after all plugins loaded)
  lua/config/autocmds.lua → User VeryLazy
```

关键点：
- **不要手动 require `config.keymaps` 等文件** — LazyVim 会自动在正确的时机加载它们
- 所有自定义插件 spec 放 `lua/plugins/` 目录，lazy.nvim 会自动发现
- 覆盖 LazyVim 默认插件配置用同名的 `"author/repo"` spec + `opts` 字段

## Common Tasks

### 添加新插件
在 `lua/plugins/` 下新建文件（如 `my-plugin.lua`）：

```lua
return {
  "author/repo",
  opts = { ... },         -- 如果插件有 LazyVim 默认配置，合并用 opts
  keys = { ... },         -- 触发加载的 keymap
  cmd = { ... },          -- 触发加载的命令
  config = function() ... end,  -- 自定义配置（无 opts 时用）
}
```

### 覆盖 LazyVim 已有插件的配置
```lua
return {
  "folke/snacks.nvim",
  opts = {
    picker = { enabled = true },
  },
}
```
LazyVim 会自动 merge `opts`。

### 添加 keymap
编辑 `lua/config/keymaps.lua`，用 `vim.keymap.set()`。

### 添加 option
编辑 `lua/config/options.lua`。

### 查看已安装的插件版本
```bash
nvim --headhead "+Lazy! log" +qa
```

## Lesson Archive

Lessons are stored as individual `.md` files in the `lessons/` subdirectory (next to this file). Each lesson documents a non-trivial pitfall or hard-won insight about this config. Read them when starting config work — they may save you the same debugging time.

### Index

- [expr-keymap-empty-return](lessons/expr-keymap-empty-return.md) — `expr = true` 返回空字符串时消费按键且丢失默认行为，非透传
- [jump-out-off-by-one](lessons/jump-out-off-by-one.md) — `nvim_win_get_cursor` 0-based 列号转 Lua 1-based 索引时 `+1` 而非 `+2`
- [app-bundle-path-lsp](lessons/app-bundle-path-lsp.md) — 从 `.app` 启动 Neovim 时 PATH 缺少 Homebrew 路径，导致 LSP 找不到 `go` 等工具

###其他值得记住但不需要单文件记录的知识

- **buffer-local keymap 优先级高于全局 keymap**：blink.cmp 在 `InsertEnter` 时设置 buffer-local keymap，会完全覆盖全局 insert mode keymap，即使 blink.cmp 没映射那个按键。自定义全局 insert mode keymap 可能在 blink.cmp 激活时不生效。
- **LazyVim 配置加载顺序**：options 在 `lazy.setup()` 期间同步加载（此时插件尚未加载，不能访问插件 API）；keymaps 和 autocmds 在 `User VeryLazy` 事件后加载。keymaps.lua 中不能依赖某插件已配置完毕，如果必须可用 `vim.api.nvim_create_autocmd("InsertEnter", ...)` 等延迟。
- **`lazy-lock.json` 是锁文件**，不要手动编辑，用 `:Lazy sync`/`:Lazy update` 管理。
- **插件仓库重命名需要更新所有引用**：mason.nvim 从 `williamboman/mason.nvim` 迁移到 `mason-org/mason.nvim`。插件名变更后需搜索所有 `.lua` 文件中的旧引用（实际配置和 example 文件都得改），然后执行 `:Lazy sync` 从新地址安装。LazyVim 启动时会提示这类变更。

## Recording New Lessons

When you solve a non-trivial problem worth remembering:

1. Create a new `.md` file in the `lessons/` directory
2. Add a link to it in the **Lesson Archive** section above
3. Include the file it relates to, the root cause, the fix, and why it was tricky
