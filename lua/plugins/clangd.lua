return {
  -- LazyVim 的 clangd extra：自动配置 lspconfig、treesitter、mason 等
  --
  -- 缩进控制（clang-format）：
  --   clangd 使用 clang-format 进行格式化，它会从源文件目录逐级向上
  --   查找 .clang-format 文件，直到家目录。因此在家目录放置全局配置
  --   即可让所有 C/C++ 项目使用统一的格式化规则：
  --
  --     ~/.clang-format:
  --       BasedOnStyle: LLVM
  --       IndentWidth: 4
  --       TabWidth: 4
  --       UseTab: Never
  --       ColumnLimit: 120
  --       AccessModifierOffset: -4
  --       AllowShortIfStatementsOnASingleLine: false
  --       AllowShortFunctionsOnASingleLine: Empty
  --
  --   如果有项目需要单独规则，在该项目根目录放自己的 .clang-format 即可，
  --   它会覆盖家目录的全局配置。
  { import = "lazyvim.plugins.extras.lang.clangd" },
}
