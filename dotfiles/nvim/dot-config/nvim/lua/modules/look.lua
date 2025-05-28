vim.o.termguicolors = true

vim.api.nvim_create_autocmd("OptionSet", {
  pattern = "background",
  callback = function()
    if vim.o.background == "dark" then
      vim.cmd[[colorscheme onedark]]
    else
      vim.cmd[[colorscheme onelight]]
    end
  end,
})
