lua << EOF
-- REMAPS

-- leader is space
vim.g.mapleader = " "

-- file explorer key
vim.keymap.set("n", "<leader>pv", "<CMD>Oil<CR>")

-- undotree
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

-- fugitive
vim.keymap.set("n", "<leader>gf", vim.cmd.Git)

-- move up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- append line
vim.keymap.set("n", "J", "mzJ`z")

-- half page jumps
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- search terms stay in the middle
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- paste - don't replace yanked content
vim.keymap.set("x", "<leader>p", [["_dP]])

-- yank to xclip
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- delete without yanking
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- format
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)
vim.keymap.set("v", "f", vim.lsp.buf.format)

-- quick fix nav
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- seek and replace
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- make exec
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- unmap arrows in normal mode
vim.keymap.set("n", "<Up>", "<nop>")
vim.keymap.set("n", "<Down>", "<nop>")
vim.keymap.set("n", "<Left>", "<nop>")
vim.keymap.set("n", "<Right>", "<nop>")

vim.keymap.set("n", "<leader>mk", "<cmd>RenderMarkdown toggle<cr>", {noremap=true, silent=true})

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
EOF

