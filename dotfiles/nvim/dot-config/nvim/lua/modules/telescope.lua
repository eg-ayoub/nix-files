local telescope = require('telescope')
telescope.load_extension('git_branch')
telescope.setup {
  pickers = {
    find_files = {
      find_command = { 'rg', '--files', '--hidden', '--follow', '-g', '!.git' },
    },
  },
}
