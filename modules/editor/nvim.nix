{ lib, inputs, pkgs, config, ... }:

let
  cfg = config.editor.nvim;
  fromGitHub = name: repo: pkgs.vimUtils.buildVimPlugin {
    pname = "${lib.strings.sanitizeDerivationName name}";
    version = repo.rev;
    src = repo;
  };
in
{
  options.editor.nvim = {
    enable = lib.mkEnableOption "enable nvim";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      ripgrep
      # needed for copilot
      luajitPackages.tiktoken_core
      copilot-language-server
      nodejs
    ];
    programs.neovim = {
      enable = true;
      extraConfig = lib.fileContents ./init.vim;
      plugins = with pkgs.vimPlugins; [
        plenary-nvim
        nui-nvim
        undotree
        vim-fugitive
        luasnip
        cmp-git
        cmp-nvim-lsp
        nvim-web-devicons
        mini-nvim
        vim-be-good
        copilot-lualine
        (fromGitHub "auto-dark-nvim" inputs.auto-dark-nvim)
        {
          plugin = gitsigns-nvim;
          config = ''
          lua << EOF
          require("gitsigns").setup()
          EOF
          '';
        }
        {
          plugin = hardtime-nvim;
          config = ''
          lua << EOF
          require("hardtime").setup()
          EOF
          '';
        }
        {
          plugin = oil-nvim;
          config = ''
          lua << EOF
          require("oil").setup()
          EOF
          '';
        }
        {
          plugin = lualine-nvim;
          config = ''
          lua << EOF
          require("lualine").setup({
            options = {
              theme = "auto",
              icons_enabled = true,
              component_separators = '|',
              section_separators = ''',
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
          EOF
          '';
        }
        {
          plugin = guess-indent-nvim;
          config = ''
          lua << EOF
          require('guess-indent').setup()
          EOF
          '';
        }
        {
          plugin = onedarkpro-nvim;
          config = ''
          lua << EOF
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

          -- transparent backgrounds
          -- vim.api.nvim_set_hl(0, "Normal", { bg = "none"})
          -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none"})
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
          plugin = copilot-lua;
          config = ''
          lua << EOF
          require('copilot').setup({
            suggestion = { enabled = false },
            panel = { enabled = false },
            server = {
              type = "binary",
              custom_server_filepath = "${pkgs.copilot-language-server}/bin/copilot-language-server",
            },
          })
          EOF
          '';
        }
        {
          plugin = copilot-cmp;
          config = ''
          lua << EOF
          require('copilot_cmp').setup()
          EOF
          '';
        }
        {
          plugin = CopilotChat-nvim;
          config = ''
          lua << EOF
          require('CopilotChat').setup()
          EOF
          '';
        }
        {
          plugin = render-markdown-nvim;
          config = ''
          lua << EOF
          local mk = require('render-markdown')
          mk.setup()
          mk.disable()
          EOF
          '';
        }
        {
          plugin = lsp-format-nvim;
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
          local telescope = require('telescope')
          telescope.setup {
            pickers = {
              find_files = {
                find_command = { 'rg', '--files', '--hidden', '--follow', '-g', '!.git' },
              },
            },
          }

          -- mappings
          vim.g.mapleader = " "
          local ts_builtin = require('telescope.builtin')
          vim.keymap.set('n', '<leader>pf', ts_builtin.find_files, {})
          vim.keymap.set('n', '<C-p>', ts_builtin.git_files, {})
          vim.keymap.set('n', '<leader>ps', ts_builtin.live_grep)
          vim.keymap.set('n', '<leader>vh', ts_builtin.help_tags, {})
          EOF
          '';
        }
        {
          plugin = lspkind-nvim;
        }
        {
          plugin = harpoon2;
          config = ''
          lua << EOF
          local harpoon = require('harpoon')
          harpoon:setup()

          -- REQUIRED
          vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
          vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

          vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
          vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end)
          vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end)
          vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end)

          -- Toggle previous & next buffers stored within Harpoon list
          vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
          vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)


          EOF
          '';
        }
        {
          plugin = nvim-cmp;
          config = ''
          lua << EOF
          local cmp = require('cmp')
          local lspkind = require('lspkind')
          cmp.setup({
            formatting = {
              format = lspkind.cmp_format({
                mode = 'symbol',
                maxwidth = {
                  menu = 50,
                  abbr = 50,
                },
                symbol_map = { Copilot ="" },
                ellipsis_char = '...',
                show_labelDetails = true,
              })
            },
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
              -- Copilot
              { name = 'copilot' },
              -- Other Sources
              { name = 'nvim_lsp' },
              { name = 'luasnip' },
              { name = 'buffer' },
              { name = 'path' },
              { name = 'render_markdown' },
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
        {
          plugin = nvim-lspconfig;
          config = lib.mkIf config.editor.servers.enable ''
          lua << EOF
          local capabilities = require('cmp_nvim_lsp').default_capabilities()
          require'lspconfig'.bashls.setup{
            capabilities = capabilities,
            filetypes = {"sh", "sh.in"},
          }
          require 'lspconfig'.pyright.setup {
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
          require 'lspconfig'.helm_ls.setup {
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
      ];
    };
  };
}
