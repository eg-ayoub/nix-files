{ lib, inputs, pkgs, config, ... }:

let
  cfg = config.editor.nvim;
in
{
  options.editor.nvim = {
    enable = lib.mkEnableOption "enable nvim";
  };

  config = lib.mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      extraConfig = lib.fileContents ./init.vim;
      plugins = with pkgs.vimPlugins; [
        plenary-nvim
        undotree
        vim-fugitive
        {
          plugin = harpoon;
          config = ''
          lua << EOF
          vim.g.mapleader = " "
          local mark = require("harpoon.mark")
          -- local ui = require("harpoon.ui")
          vim.keymap.set("n", "<leader>a", mark.add_file)
          -- vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end)
          -- vim.keymap.set("n", "<C-t>", function() ui.nav_file(2) end)
          -- vim.keymap.set("n", "<C-n>", function() ui.nav_file(3) end)
          -- vim.keymap.set("n", "<C-s>", function() ui.nav_file(4) end)
          EOF
          '';
        }
        {
          plugin = tokyonight-nvim;
          config = ''
          lua << EOF
          vim.cmd[[colorscheme tokyonight-moon]]

          -- transparent backgrounds
          vim.api.nvim_set_hl(0, "Normal", { bg = "none"})
          vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none"})
          EOF
          '';
        }
        {
          plugin = nvim-colorizer-lua;
          config = ''
          lua << EOF
          require('colorizer').setup()
          EOF
          '';
        }
        {
          plugin = nvim-treesitter.withAllGrammars;
          config = ''
          lua << EOF
          require'nvim-treesitter.configs'.setup {
              highlight = {
                  enable = true,
                  additional_vim_regex_highlighting = false,
              },
          }
          EOF
          '';
        }
        {
          plugin = telescope-nvim;
          config = ''
          lua << EOF
          vim.g.mapleader = " "
          local ts_builtin = require('telescope.builtin')
          vim.keymap.set('n', '<leader>pf', ts_builtin.find_files, {})
          vim.keymap.set('n', '<C-p>', ts_builtin.git_files, {})
          vim.keymap.set('n', '<leader>ps', ts_builtin.live_grep)
          vim.keymap.set('n', '<leader>vh', ts_builtin.help_tags, {})
          vim.keymap.set("n", "<C-e>", "<cmd>:Telescope harpoon marks<CR>")
          require("telescope").load_extension('harpoon')
          EOF
          '';
        }

      ];
    };
  };
}
