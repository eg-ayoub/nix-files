require("lualine").setup({
  options = {
    theme = "auto",
    icons_enabled = true,
    component_separators = '|',
    section_separators = '',
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype', 'copilot'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
})
