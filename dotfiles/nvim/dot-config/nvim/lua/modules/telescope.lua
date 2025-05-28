local telescope = require('telescope')
telescope.setup {
  pickers = {
    find_files = {
      find_command = { 'rg', '--files', '--hidden', '--follow', '-g', '!.git' },
    },
  },
}
