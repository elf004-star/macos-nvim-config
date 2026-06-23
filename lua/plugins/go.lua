return {
  -- gopls 配置：启用静态分析、未使用参数检查等
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
                shadow = true,
              },
              staticcheck = true,
              gofumpt = true, -- 使用 gofumpt 进行更严格的格式化（需要 go install mvdan.cc/gofumpt@latest）
            },
          },
        },
      },
    },
  },
}
