return {
  -- texlab LaTeX LSP 配置
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        texlab = {
          settings = {
            texlab = {
              chktex = {
                onOpenAndSave = true,
                onEdit = false,
              },
            },
          },
        },
      },
    },
  },
  -- 格式化：使用 tex-fmt（通过 Mason 安装）
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        tex = { "tex-fmt" },
        bib = { "tex-fmt" },
      },
    },
  },
}
