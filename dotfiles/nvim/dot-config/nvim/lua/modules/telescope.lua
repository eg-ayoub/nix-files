local telescope = require('telescope')
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
    live_grep = {
      additional_args = { '--hidden', '--follow', '-g', '!.git' },
    },
  },
}
