-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode with jk" })

-- Jump out of brackets/quotes — moves cursor past the next closing character
local function jump_out()
  local col = vim.api.nvim_win_get_cursor(0)[2] -- 0-based column
  local next = vim.api.nvim_get_current_line():sub(col + 1, col + 1)
  if next ~= "" and next:match("[%]})>\"'`]") then
    return "<Right>"
  end
  return ""
end

vim.keymap.set("i", "<C-]>", "<Right>", { desc = "Move cursor right (Ctrl+])" })
vim.keymap.set("i", "<C-[>", "<Left>", { desc = "Move cursor left (Ctrl+[) -- may break <Esc> in terminals" })
vim.keymap.set("i", "<C-j>", jump_out, { expr = true, desc = "Jump out of bracket/quote" })

-- Ctrl+Enter in insert mode: exit insert mode and open new line below
vim.keymap.set("i", "<C-CR>", "<Esc>o", { desc = "Exit insert and open new line below (Ctrl+Enter)" })
-- Shift+Enter in insert mode: exit insert mode, move down, open new line above
vim.keymap.set("i", "<S-CR>", "<Esc>jO", { desc = "Exit insert, move down, open new line above (Shift+Enter)" })

-- Toggle line wrap (global)
vim.keymap.set("n", "<leader>uw", function()
  vim.wo.wrap = not vim.wo.wrap
  if vim.wo.wrap then
    vim.notify("Wrap: on", vim.log.levels.INFO, { title = "Line Wrap" })
  else
    vim.notify("Wrap: off", vim.log.levels.INFO, { title = "Line Wrap" })
  end
end, { desc = "Toggle wrap" })
