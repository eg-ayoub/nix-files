local telescope = require('telescope')
telescope.load_extension('git_branch')
telescope.setup {
  defaults = {
    file_ignore_patterns = {
      "%.uid",
      "%.png %.jpg %.svg",
      "%.import",
    },
  },
  pickers = {
    find_files = {
      find_command = { 'rg', '--files', '--hidden', '--follow', '-g', '!.git' },
    },
  },
}
