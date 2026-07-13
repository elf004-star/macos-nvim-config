return {
  "mason-org/mason.nvim",
  opts = {
    ensure_installed = {
      "gopls",
      "rust-analyzer",
      "clangd",
      "basedpyright",
      "json-lsp",
      "texlab",
      "tex-fmt",
    },
  },
}
