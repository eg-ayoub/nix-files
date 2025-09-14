local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.lsp.config('bashls', {
  capabilities = capabilities,
  filetypes = {"sh", "sh.in"},
})
vim.lsp.enable('bashls')

vim.lsp.config('pyright', {
  capabilities = capabilities,
})
vim.lsp.enable('pyright')

vim.lsp.config('clangd', {
  capabilities = capabilities,
})
vim.lsp.enable('clangd')

vim.lsp.config('yamlls', {
  capabilities = capabilities,
})
vim.lsp.enable('yamlls')

vim.lsp.config('marksman', {
  capabilities = capabilities,
})
vim.lsp.enable('marksman')

vim.lsp.config('gopls', {
  capabilities = capabilities,
})
vim.lsp.enable('gopls')

vim.lsp.config('clangd', {
  capabilities = capabilities,
})
vim.lsp.enable('clangd')

vim.lsp.config('cmake', {
  capabilities = capabilities,
})
vim.lsp.enable('cmake')

vim.lsp.config('nixd', {
  capabilities = capabilities,
})
vim.lsp.enable('nixd')

vim.lsp.config('helm_ls', {
  capabilities = capabilities,
})
vim.lsp.enable('helm_ls')

vim.lsp.config('lua_ls', {
  on_init = function(client)
    local path = client.workspace_folders[1].name
      if not vim.loop.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
        client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
          Lua = {
            runtime = {
              version = 'LuaJIT'
            },
            diagnostics = {
              globals = {'vim'}
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
})
vim.lsp.enable('lua_ls')

vim.lsp.config('gdscript', {
  capabilities = capabilities,
})
vim.lsp.enable('gdscript')
