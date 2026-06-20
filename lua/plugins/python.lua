return {
  -- 使用 basedpyright 替代官方 pyright
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "basic", -- "off" | "basic" | "standard" | "strict"
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
              },
            },
          },
        },
      },
      -- 禁用 pyright（如果已经装了），只启用 basedpyright
      setup = {
        pyright = function()
          -- 不设置 pyright，只保留 basedpyright
          return true
        end,
      },
    },
  },
}
