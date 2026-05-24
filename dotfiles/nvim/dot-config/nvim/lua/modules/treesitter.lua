require('nvim-treesitter').install {
  'go', 'python', 'lua', 'markdown', 'vim', 'yaml', 'cpp', 'gdscript', 'nix',
  'bash', 'json'
}

vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    pcall(vim.treesitter.start)
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
