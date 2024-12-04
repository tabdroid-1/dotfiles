require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("v", "p", "P")
map("v", "P", "p")

function toggleCppHpp()
  local current_file = vim.fn.expand "%"
  local file_extension = vim.fn.expand "%:e"

  if file_extension == "cpp" then
    local hpp_file = vim.fn.expand "%:r" .. ".h"
    vim.cmd("edit " .. hpp_file)
  elseif file_extension == "h" then
    local cpp_file = vim.fn.expand "%:r" .. ".cpp"
    vim.cmd("edit " .. cpp_file)
  else
    print "Unsupported file extension"
  end
end

-- vim.api.nvim_set_keymap("n", "<Tab>", ":lua toggleCppHpp()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Tab>", ":lua toggleCppHpp()<CR>", { noremap = true, silent = true })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
