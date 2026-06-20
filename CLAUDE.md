# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture

This is a [LazyVim](https://github.com/LazyVim/LazyVim) starter-based Neovim configuration. LazyVim provides the default setup for plugins, keymaps, options, and autocmds — this repo only contains overrides and additions.

### File structure

| Path | Purpose |
|------|---------|
| `init.lua` | Entry point; boots lazy.nvim via `config.lazy` |
| `lua/config/lazy.lua` | Bootstraps lazy.nvim (auto-clones if missing) and defines the plugin spec list |
| `lua/config/options.lua` | Neovim option overrides (extends LazyVim defaults) |
| `lua/config/keymaps.lua` | Custom keymaps (extends LazyVim defaults) |
| `lua/config/autocmds.lua` | Custom autocommands (extends LazyVim defaults) |
| `lua/plugins/*.lua` | Plugin specs — each file returns a lazy.nvim plugin spec (table or list of tables); loaded automatically by lazy.nvim |
| `lazy-lock.json` | Lock file pinning plugin commits; managed by `:Lazy` |
| `lazyvim.json` | LazyVim install metadata (extras, version) |
| `stylua.toml` | Lua formatting config (spaces, 2 indent, 120 column width) |
| `.neoconf.json` | neoconf.nvim settings for Lua LSP |

### How plugins work

Each file in `lua/plugins/` returns a lazy.nvim spec table (or list of tables). Specs can:
- Add new plugins with `{ "author/repo", opts = {...}, keys = {...}, ... }`
- Override LazyVim defaults by using the same plugin key (e.g. `{ "folke/trouble.nvim", opts = {...} }`)
- Import extra plugin groups with `{ import = "lazyvim.plugins.extras.lang.typescript" }`

The `lua/plugins/example.lua` file shows common override patterns (disabled by `if true then return {} end`).

### Key plugins in use

- snacks.nvim — dashboard, picker, notifier, indent, scroll, terminal, explorer, image, zen, big-file, lazygit, rename, input, words, dim, scope, profiler
- blink.cmp — completion engine
- catppuccin / tokyonight — colorschemes (tokyonight is the installer default)
- mason.nvim + nvim-lspconfig — LSP server management
- nvim-treesitter — syntax highlighting and text objects
- lualine.nvim — statusline
- which-key.nvim — keymap discovery popup
- noice.nvim — cmdline and message UI
- trouble.nvim — diagnostics, quickfix, references
- gitsigns.nvim — git sign column
- flash.nvim — fast navigation
- conform.nvim — code formatting
- grug-far.nvim — search & replace across files
- persistence.nvim — session management
- todo-comments.nvim — TODO/FIXME highlighting

## Common tasks

### Add a new plugin
Create a new file in `lua/plugins/` (e.g. `lua/plugins/my-plugin.lua`) returning a spec:
```lua
return {
  "author/repo",
  config = function()
    -- setup code
  end,
}
```
Or merge into an existing plugin's options if the plugin is already declared by LazyVim.

### Override a LazyVim plugin option
Add a spec with the same plugin URL and an `opts` field:
```lua
return {
  "folke/snacks.nvim",
  opts = {
    picker = { enabled = true },
  },
}
```

### Add a custom keymap
Edit `lua/config/keymaps.lua` using `vim.keymap.set()`.

### Add a custom option
Edit `lua/config/options.lua` — e.g. `vim.opt.relativenumber = true`.

### Update plugins
Run `:Lazy sync` or `:Lazy update` inside Neovim.

### Format Lua files
```bash
stylua lua/
```

### Check plugin status
```bash
nvim --headless "+Lazy! sync" +qa
```

## Knowledge management

This project has a dedicated skill with a bundled lesson archive for accumulating non-trivial knowledge:

- **Skill** (`.claude/skills/nvim-config/SKILL.md`) — architecture, common tasks, and a lesson archive.
- **Lesson archive** (`.claude/skills/nvim-config/lessons/`) — individual `.md` files, each documenting a specific pitfall or hard-won insight. These are the persistent record; read them before starting config work and add to them after complex debugging.

When completing a complex or non-obvious task that involved debugging, gotchas, or anything worth remembering:
1. **Suggest creating a lesson file** — add a new `.md` in `.claude/skills/nvim-config/lessons/` and link it in the SKILL.md Lesson Archive index.
2. **If the insight is small** — just add a bullet to the "其他值得记住但不需要单文件记录的知识" section in SKILL.md.

Simple or routine changes (adding a plugin, tweaking an option, adding a straightforward keymap) don't need recording — only non-obvious things that took effort to figure out.
