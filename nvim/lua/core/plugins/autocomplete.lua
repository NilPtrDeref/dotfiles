return {
  'saghen/blink.cmp',
  dependencies = 'rafamadriz/friendly-snippets',
  version = '*',
  opts = {
    sources = {
      default = { 'lsp', 'snippets', 'path', 'buffer' },
      providers = {
        lsp = {
          name = 'lsp',
          enabled = true,
          module = 'blink.cmp.sources.lsp',
          score_offset = 1000,
          fallbacks = { 'buffer' },
        },
        snippets = {
          name = 'snippets',
          enabled = true,
          module = 'blink.cmp.sources.snippets',
          score_offset = 950,
          max_items = 3,
          fallbacks = { 'buffer' },
        },
        path = {
          name = 'path',
          enabled = true,
          module = 'blink.cmp.sources.path',
          score_offset = 900,
          fallbacks = { 'buffer' },
        },
        buffer = {
          name = 'buffer',
          enabled = true,
          module = 'blink.cmp.sources.buffer',
          score_offset = 800,
          max_items = 3,
          min_keyword_length = 4,
        },
      },
    },
    keymap = {
      preset = 'default',
      ['<C-l>'] = { 'snippet_forward', 'fallback' },
      ['<C-h>'] = { 'snippet_backward', 'fallback' },
    },
    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = 'mono'
    },
    completion = {
      menu = {
        border = 'single',
        max_height = 20,
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = {
          border = 'single',
          max_height = 40,
          max_width = 120,
        },
      },
      list = {
        selection = {
          auto_insert = false,
        },
      },
    },
    signature = {
      enabled = true,
      window = {
        border = 'single',
        max_height = 40,
        max_width = 120,
      },
    },
  },
  opts_extend = { "sources.default" }
}
