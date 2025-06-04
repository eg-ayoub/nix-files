vim.o.termguicolors = true

local neopywal = require("neopywal")
vim.cmd[[colorscheme neopywal]]

 vim.api.nvim_create_autocmd("OptionSet", {
   pattern = "background",
   callback = function()
     if vim.o.background == "dark" then
       -- vim.cmd[[colorscheme onedark]]
       vim.cmd[[colorscheme neopywal-light]]
     else
       -- vim.cmd[[colorscheme onelight]]
       vim.cmd[[colorscheme neopywal-dark]]
     end
   end,
 })
