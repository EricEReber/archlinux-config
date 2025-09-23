require('options')
require('keymaps')
require('functions')
require('autocommands')
require('lazy_init')
-- vim.api.nvim_set_hl(0, "@keyword", { fg = "#red" })
-- vim.api.nvim_set_hl(0, "@conditional", { fg = "#f906bf" })
-- vim.api.nvim_set_hl(0, "@repeat", { fg = "#f906bf" })
-- vim.api.nvim_set_hl(0, "@include", { fg = "#f906bf" })
-- vim.api.nvim_set_hl(0, "@keyword", { fg = "#d91254" })
-- vim.api.nvim_set_hl(0, "@keyword.pass", { fg = "#d91254" })

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = "*.py",
  callback = function()
    vim.fn.matchadd("Todo", [[\v<(TODO|FIXME|NOTE)>]])
  end,
})
