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
| `lua/plugins/mason.lua` | `mason.nvim` config with `ensure_installed` list of LSP servers |
| `lazy-lock.json` | Lock file pinning plugin commits; managed by `:Lazy` |
| `lazyvim.json` | LazyVim install metadata (extras, version) |
| `stylua.toml` | Lua formatting config (spaces, 2 indent, 120 column width) |
| `.neoconf.json` | neoconf.nvim settings for Lua LSP (enables neodev library and neoconf plugins for lua_ls) |
| `test.c` | Scratch file for testing C LSP (`clangd`) and `clang-format` formatting |

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

### Language support (extras imported in `lua/config/lazy.lua`)

| Language | LSP Server | Formatter | Enabled via |
|----------|-----------|-----------|-------------|
| Python | `basedpyright` (custom config in `lua/plugins/python.lua`) | (conform default) | `lazyvim.plugins.extras.lang.python` |
| Rust | `rust-analyzer` | `rustfmt` (explicit in `lua/plugins/rust.lua`) | `lazyvim.plugins.extras.lang.rust` |
| Go | `gopls` (staticcheck + gofumpt enabled in `lua/plugins/go.lua`) | (conform default) | `lazyvim.plugins.extras.lang.go` |
| C/C++ | `clangd` | `clang-format` via `~/.clang-format` (docs in `lua/plugins/clangd.lua`) | `lazyvim.plugins.extras.lang.clangd` |
| JSON | `jsonls` (with schema validation for `package.json`, `tsconfig.json`, `lazy-lock.json` in `lua/plugins/json.lua`) | `jq` (via conform, requires `brew install jq`) | — |

LSP servers listed above are auto-installed via `mason.nvim` (see `lua/plugins/mason.lua` for the `ensure_installed` list).

### Notable customizations

- **basedpyright instead of pyright** — `lua/plugins/python.lua` enables `basedpyright` (more complete type checking) and disables the stock pyright via the `setup` hook.
- **JSON schemas** — `lua/plugins/json.lua` registers `package.json`, `tsconfig.json`, and `lazy-lock.json` schemas for validation. JSON formatting uses `jq` (must be installed separately via `brew install jq`).
- **Go LSP** — `lua/plugins/go.lua` enables `staticcheck`, `unusedparams`, `shadow` analyses, and `gofumpt` formatting (requires `go install mvdan.cc/gofumpt@latest`).
- **Default 4-space indent, 2-space for Lua** — `lua/config/options.lua` sets `tabstop=4`/`shiftwidth=4` as the global default (LazyVim's default is 2), then overrides to 2 for Lua files via a FileType autocmd.
- **macOS Homebrew PATH fix** — `lua/config/options.lua` prepends `/opt/homebrew/bin` to PATH so LSP tools (gopls, clangd, etc.) work when Neovim is launched from a `.app` bundle (which doesn't inherit `~/.zshrc`).
- **C/C++ formatting** — clangd delegates to `clang-format`, which searches upward from the source file for `.clang-format`. The user keeps a global `~/.clang-format` (LLVM style, 4-space indent, 120 column limit) as fallback.

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

Current custom keymaps:
| Mode | Key | Action |
|------|-----|--------|
| Insert | `jk` | Exit to Normal mode |
| Insert | `<C-]>` or `<C-j>` | Jump out of bracket/quote (moves cursor past `]}>)>"'`\`) |
| Normal | `<leader>uw` | Toggle line wrap |

### Add a custom option
Edit `lua/config/options.lua` — e.g. `vim.opt.relativenumber = true`.

### Update plugins
Run `:Lazy sync` or `:Lazy update` inside Neovim.

### Validate config loads correctly
```bash
nvim --headless -c "checkhealth" -c "qall"
```
This verifies all plugins load, LSP servers are available, and no startup errors occur.

### Format Lua files
```bash
stylua lua/
```

### Check plugin status
```bash
nvim --headless "+Lazy! sync" +qa
```

### Commit changes
```bash
git add -A && git commit -m "description of change"
# End commit messages with:
# Co-Authored-By: Claude <noreply@anthropic.com>
```

### Required external tools
Tools that aren't installed by `mason.nvim` and must exist on the system:
- **`jq`** — JSON formatting (install via `brew install jq`)
- **`gofumpt`** — stricter Go formatting (`go install mvdan.cc/gofumpt@latest`)
- **`clang-format`** — C/C++ formatting (part of LLVM, installed via `brew install llvm` or Xcode CLT)
- **LSP servers** listed in the language support table are auto-installed by `mason.nvim`

## Knowledge management

This project has a dedicated skill with a bundled lesson archive for accumulating non-trivial knowledge:

- **Skill** (`.claude/skills/nvim-config/SKILL.md`) — architecture, common tasks, and a lesson archive.
- **Lesson archive** (`.claude/skills/nvim-config/lessons/`) — individual `.md` files, each documenting a specific pitfall or hard-won insight. These are the persistent record; read them before starting config work and add to them after complex debugging.

When completing a complex or non-obvious task that involved debugging, gotchas, or anything worth remembering:
1. **Suggest creating a lesson file** — add a new `.md` in `.claude/skills/nvim-config/lessons/` and link it in the SKILL.md Lesson Archive index.
2. **If the insight is small** — just add a bullet to the "其他值得记住但不需要单文件记录的知识" section in SKILL.md.

Simple or routine changes (adding a plugin, tweaking an option, adding a straightforward keymap) don't need recording — only non-obvious things that took effort to figure out.
