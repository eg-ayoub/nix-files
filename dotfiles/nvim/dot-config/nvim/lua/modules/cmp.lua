local blink = require('blink.cmp')
blink.setup({
  keymap = {
    preset = 'default',
    ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
    ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
    ['<CR>'] = { 'accept', 'fallback' },
  },
  snippets = { preset = 'luasnip' },
  appearance = {
    nerd_font_variant = 'mono',
    kind_icons = {
      Copilot = '',
    },
  },
  completion = {
    list = {
      selection = {
        preselect = false,
        auto_insert = false,
      },
    },
    ghost_text = { enabled = false },
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer', 'copilot', 'git' },
    per_filetype = {
      gitcommit = { 'git', 'buffer' },
    },
    providers = {
      copilot = {
        name = 'copilot',
        module = 'blink-cmp-copilot',
        async = true,
        score_offset = 100,
      },
      git = {
        name = 'git',
        module = 'cmp_git.blink',
      },
    },
  },
  cmdline = {
    keymap = { preset = 'cmdline' },
    completion = { menu = { auto_show = true } },
  },
})
