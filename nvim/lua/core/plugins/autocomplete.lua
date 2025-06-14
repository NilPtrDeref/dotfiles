return {
  'saghen/blink.cmp',
  dependencies =
  {
    'rafamadriz/friendly-snippets',
    'giuxtaposition/blink-cmp-copilot'
  },
  version = '*',
  opts = {
    sources = {
      default = { 'lsp', 'snippets', 'path', 'copilot', 'buffer' },
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
          max_items = 5,
          fallbacks = { 'buffer' },
        },
        path = {
          name = 'path',
          enabled = true,
          module = 'blink.cmp.sources.path',
          score_offset = 900,
          max_items = 3,
          fallbacks = { 'buffer' },
        },
        copilot = {
          name = "copilot",
          enabled = true,
          module = "blink-cmp-copilot",
          score_offset = 800,
          async = true,
          fallbacks = { 'buffer' },
          transform_items = function(_, items)
            local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
            local kind_idx = #CompletionItemKind + 1
            CompletionItemKind[kind_idx] = "Copilot"
            for _, item in ipairs(items) do
              item.kind = kind_idx
            end
            return items
          end,
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
      nerd_font_variant = 'mono',
      kind_icons = {
        Copilot = "",
        Text = '󰉿',
        Method = '󰊕',
        Function = '󰊕',
        Constructor = '󰒓',

        Field = '󰜢',
        Variable = '󰆦',
        Property = '󰖷',

        Class = '󱡠',
        Interface = '󱡠',
        Struct = '󱡠',
        Module = '󰅩',

        Unit = '󰪚',
        Value = '󰦨',
        Enum = '󰦨',
        EnumMember = '󰦨',

        Keyword = '󰻾',
        Constant = '󰏿',

        Snippet = '󱄽',
        Color = '󰏘',
        File = '󰈔',
        Reference = '󰬲',
        Folder = '󰉋',
        Event = '󱐋',
        Operator = '󰪚',
        TypeParameter = '󰬛',
      },
    },
    completion = {
      menu = {
        -- Disable automatically opening autocomplete menu when false. Only show it when manually requested.
        auto_show = true,
        border = 'single',
        max_height = 20,
        draw = {
          components = {
            label = {
              width = { fill = true, max = 200 },
              text = function(ctx) return ctx.label .. ctx.label_detail end,
              highlight = function(ctx)
                -- label and label details
                local highlights = {
                  { 0, #ctx.label, group = ctx.deprecated and 'BlinkCmpLabelDeprecated' or 'BlinkCmpLabel' },
                }
                if ctx.label_detail then
                  table.insert(highlights, { #ctx.label, #ctx.label + #ctx.label_detail, group = 'BlinkCmpLabelDetail' })
                end

                -- characters matched on the label by the fuzzy matcher
                for _, idx in ipairs(ctx.label_matched_indices) do
                  table.insert(highlights, { idx, idx + 1, group = 'BlinkCmpLabelMatch' })
                end

                return highlights
              end,
            },
          },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = {
          border = 'single',
          max_height = 40,
          max_width = 160,
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
        max_width = 160,
      },
    },
  },
  opts_extend = { "sources.default" }
}
