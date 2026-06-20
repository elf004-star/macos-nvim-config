return {
  -- 显式配置 rustfmt 作为 Rust 的格式化工具
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        rust = { "rustfmt" },
      },
    },
  },
}
