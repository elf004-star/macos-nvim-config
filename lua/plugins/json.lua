return {
  -- LSP 配置：验证、补全、hover 等
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        jsonls = {
          -- mason 会自动安装 json-lsp（已在 mason.lua 的 ensure_installed 中配置）
          settings = {
            json = {
              schemas = {
                {
                  fileMatch = { "package.json" },
                  url = "https://json.schemastore.org/package.json",
                },
                {
                  fileMatch = { "tsconfig.json", "tsconfig.*.json" },
                  url = "https://json.schemastore.org/tsconfig.json",
                },
                {
                  fileMatch = { "lazy-lock.json" },
                  url = "https://json.schemastore.org/package",
                },
              },
              validate = { enabled = true },
            },
          },
        },
      },
    },
  },
  -- 格式化：使用 jq（已通过 Homebrew 安装）
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        json = { "jq" },
        jsonc = { "jq" },
      },
    },
  },
}
