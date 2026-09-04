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
-- nvm-managed node: .app bundle doesn't inherit ~/.zshrc, so jsonls / tsserver
-- etc. fail with "env: node: No such file or directory" (exit 127)
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
