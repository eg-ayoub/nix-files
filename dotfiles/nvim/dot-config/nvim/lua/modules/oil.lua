require("oil").setup({
  view_options = {
    show_hidden = false,
    is_hidden_file = function (name, _)
      return vim.startswith(name, ".") or vim.endswith(name, ".uid")
    end
  },
  win_options = {
    signcolumn = "yes:2",
  },
})
require("oil-git-status").setup()
