-- blink.cmp 自定义配置
-- super-tab preset: Tab 选中/确认补全，回车确认补全，类似 VSCode 体验
return {
  "saghen/blink.cmp",
  opts = {
    keymap = {
      preset = "super-tab",
      ["<CR>"] = { "select_and_accept", "fallback" },
    },
  },
}
