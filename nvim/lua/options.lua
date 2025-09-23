local g = vim.g
local opt = vim.opt
local data = vim.env.XDG_DATA_HOME

g.mapleader = " "
g.maplocalleader = " "

-- indents

opt.smartindent = true

opt.smartindent = true
opt.expandtab = true
opt.breakindent = true
opt.shiftwidth = 4
opt.tabstop = 4

g.pyindent_open_paren = vim.opt.shiftwidth:get()


-- visuals
opt.relativenumber = true
opt.number = true
opt.scrolloff = 999
opt.cursorline = true
opt.list = true
opt.listchars= "lead:·,trail:·,tab:>·"


g.netrw_banner = 0

-- mouse
opt.mouse = "a"

opt.ignorecase = true
opt.smartcase = true

opt.spelllang = "nb,en"

opt.title = true

opt.titlestring = "nvim   %F"


opt.undofile = true
opt.undodir = { data .. "/nvim/undo_dir//" }

opt.backup = false
opt.writebackup = false

opt.signcolumn = "yes"

opt.foldlevel = 99


local statusline = ' '
statusline = statusline .. '%{gitbranch#name()} '    -- Git branch
statusline = statusline .. '%#LineNr#'               -- Line number highlight group
statusline = statusline .. '%1* %<' .. '%f %m%r%h%w '-- File information
statusline = statusline .. '%='                      -- Right align
statusline = statusline .. '%#CursorColumn#'         -- Cursor column highlight group
statusline = statusline .. '[%{&fileencoding?&fileencoding:&encoding}] '
statusline = statusline .. '%p%% '                   -- Percentage through file
statusline = statusline .. '%l:%c '                  -- Line and column numbers

opt.statusline = statusline

-- coc things
opt.hidden = true
opt.updatetime = 300
opt.shortmess:append('c')


vim.cmd([[colorscheme onethirdlight]])


-- Check if SSH_TTY is set
if vim.fn.getenv('SSH_TTY') ~= vim.NIL then
  vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
      ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
      ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    },
    paste = {
      ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
      ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
    },
  }
end
