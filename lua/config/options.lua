-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Ensure Homebrew and ~/.local/bin directories are in PATH (fixes LSP tools and
-- sioyek when Neovim is launched from a macOS .app bundle, which doesn't inherit
-- the shell's PATH from ~/.zshrc)
if not vim.env.PATH:find("/opt/homebrew/bin", 1, true) then
  vim.env.PATH = "/opt/homebrew/bin:/opt/homebrew/sbin:" .. vim.env.PATH
end
if not vim.env.PATH:find(".local/bin", 1, true) then
  vim.env.PATH = vim.fn.expand("~/.local/bin") .. ":" .. vim.env.PATH
end
-- ~/bin (for latexmk when Neovim is launched from .app bundle)
if not vim.env.PATH:find(vim.fn.expand("~/bin"), 1, true) then
  vim.env.PATH = vim.fn.expand("~/bin") .. ":" .. vim.env.PATH
end

-- Default: 4-space indentation (C, Go, Python, etc.)
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

-- Lua files: 2-space indentation
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
  end,
  desc = "Use 2-space indent for Lua files",
})
