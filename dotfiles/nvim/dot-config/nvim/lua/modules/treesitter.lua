require'nvim-treesitter.configs'.setup {
    ensure_installed = { "go", "python", "lua", "markdown", "vim", "yaml", "cpp" },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
  }
