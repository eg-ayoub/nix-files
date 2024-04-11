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
        luasnip
        cmp-git
        cmp-nvim-lsp
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
        {
          plugin = nvim-cmp;
          config = ''
          lua << EOF
          local cmp = require('cmp')
          cmp.setup({
            snippet = {
              expand = function(args)
                require('luasnip').lsp_expand(args.body)
              end,
            },
            mapping = cmp.mapping.preset.insert({
              ["<CR>"] = cmp.mapping.confirm({ select = false }),
              ["<Tab>"] = cmp.mapping.select_next_item(),
              ["<C-p>"] = cmp.mapping.select_prev_item(),
              ["<C-n>"] = cmp.mapping.select_next_item(),
              ["<C-Space>"] = cmp.mapping.complete(),
              ["<C-e>"] = cmp.mapping.abort(),
            }),
            sources = cmp.config.sources({
              { name = 'nvim_lsp' },
              { name = 'luasnip' },
              { name = 'buffer' },
              { name = 'path' },
            }),
          })
          cmp.setup.filetype('gitcommit', {
            sources = cmp.config.sources({
              { name = 'git' }, 
            }, {
              { name = 'buffer' },
            })
          })
          cmp.setup.cmdline({ '/', '?' }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
              { name = 'buffer' }
            }
          })
          cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
              { name = 'path' }
            }, {
              { name = 'cmdline' }
            })
          })
          EOF
          '';
        }
        {
          plugin = nvim-lspconfig;
          config = lib.mkIf config.editor.servers.enable ''
          lua << EOF
          local capabilities = require('cmp_nvim_lsp').default_capabilities()
          require'lspconfig'.bashls.setup{
            capabilities = capabilities,
            filetypes = {"sh", "sh.in"},
          }
          require 'lspconfig'.pylsp.setup {
            capabilities = capabilities,
          }
          require 'lspconfig'.yamlls.setup {
            capabilities = capabilities,
          }
          require 'lspconfig'.marksman.setup {
            capabilities = capabilities,
          }
          require 'lspconfig'.gopls.setup {
            capabilities = capabilities,
          } 
          require 'lspconfig'.clangd.setup {
            capabilities = capabilities,
          }
          require 'lspconfig'.cmake.setup {
            capabilities = capabilities,
          }
          require 'lspconfig'.nixd.setup {
            capabilities = capabilities,
          }
          require 'lspconfig'.lua_ls.setup {
            on_init = function(client)
              local path = client.workspace_folders[1].name
                if not vim.loop.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
                  client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
                    Lua = {
                      runtime = {
                        version = 'LuaJIT'
                      },
                      workspace = {
                        checkThirdParty = false,
                        library = {
                          vim.env.VIMRUNTIME
                        }
                      }
                    }
                  })
                  client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
                end
                return true
              end,
              capabilities = capabilities,
          }
          EOF
          '';
        }
        {
          plugin = lsp-zero-nvim;
          config = ''
          lua << EOF
          local lsp_zero = require('lsp-zero')
          lsp_zero.on_attach(function(client, bufnr)
            lsp_zero.default_keymaps({ buffer = bufnr })
          end)
          EOF
          '';
        }
      ];
    };
  };
}
