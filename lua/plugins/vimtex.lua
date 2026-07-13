return {
  "lervag/vimtex",
  lazy = false,
  init = function()
    vim.g.vimtex_view_method = "sioyek"
    vim.g.vimtex_compiler_method = "latexmk"
    vim.g.vimtex_compiler_latexmk = {
      out_dir = "Build",
      continuous = 1,
    }
    -- g:vimtex_compiler_latexmk_engines 是独立变量，不是嵌套在 compiler_latexmk 里
    vim.g.vimtex_compiler_latexmk_engines = {
      _ = "-xelatex",
    }
  end,
}
