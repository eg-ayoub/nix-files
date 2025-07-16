local capabilities = require('cmp_nvim_lsp').default_capabilities()
require'lspconfig'.bashls.setup{
  capabilities = capabilities,
  filetypes = {"sh", "sh.in"},
}
require 'lspconfig'.pyright.setup {
  capabilities = capabilities,
}
require 'lspconfig'.clangd.setup {
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
