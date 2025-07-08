require("oil-git-status").setup()
require("oil").setup({
  view_options = {
    show_hidden = true,
  },
  win_options = {
    signcolumn = "yes:2",
  },
})
