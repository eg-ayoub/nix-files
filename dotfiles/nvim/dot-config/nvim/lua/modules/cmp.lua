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
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'copilot' },
    { name = 'git' },
    { name = 'path' },
    { name = 'render_markdown' },
    { name = 'nvim_lua' },
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
