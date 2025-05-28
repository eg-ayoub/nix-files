-- leader is space
vim.g.mapleader = " "

-- file explorer key
vim.keymap.set("n", "<leader>pv", "<Cmd>Oil<CR>")

-- telescope
local ts_builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', ts_builtin.find_files, {})
vim.keymap.set('n', '<C-p>', ts_builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', ts_builtin.live_grep)
vim.keymap.set('n', '<leader>vh', ts_builtin.help_tags, {})
