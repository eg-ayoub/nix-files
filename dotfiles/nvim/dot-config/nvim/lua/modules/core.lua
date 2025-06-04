-- LINES

--list
vim.opt.list = true
vim.opt.listchars = { eol = '↵', tab = '▏ ', leadmultispace = '▏ ', trail = '✕', extends = '⇥', precedes = '⇤' }

-- tabspaces
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- line wrap
vim.opt.wrap = false

-- MISC

-- undo stuff
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- search
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- colors
vim.opt.termguicolors = true

-- scroll
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

-- fast update time
vim.opt.updatetime = 50

-- to avoid pylint line too long
vim.opt.colorcolumn = "100"

-- always show tabs
vim.opt.showtabline = 2

-- mode is shown in tabline
vim.opt.showmode = false

-- enable diagnostic lines globally
vim.diagnostic.config({
  virtual_text = {
    prefix = '', -- Could be '●', '▎', 'x'
  },
  signs = true,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
})
