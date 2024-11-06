require "nvchad.options"

local o = vim.o
o.expandtab = true
o.shiftwidth = 4
o.smartindent = true
o.tabstop = 4
o.softtabstop = 4

o.commentstring = "// %s"

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "javascript", "java" },
  callback = function()
    vim.opt_local.commentstring = "// %s"
  end,
})
