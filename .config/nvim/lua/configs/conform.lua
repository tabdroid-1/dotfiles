local options = {

  lazy = false,
  formatters_by_ft = {
    c = { "clang-format" },
    cpp = { "clang-format" },
    h = { "clang-format" },
    hpp = { "clang-format" },
    lua = { "stylua" },
    -- css = { "prettier" },
    -- html = { "prettier" },
  },


  format_on_save = {
    timeout_ms = 200,
    lsp_fallback = true,
  },
}

return options
