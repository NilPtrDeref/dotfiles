return {
  {
    'rebelot/kanagawa.nvim',
    dependencies = {
      -- 'Shatur/neovim-ayu',
      -- 'jake-wilcox/afterglow.nvim',
      -- 'catppuccin/nvim',
      -- 'rose-pine/neovim',
      -- 'stevearc/nightfox.nvim',
      -- 'sainnhe/sonokai',
      -- 'sainnhe/everforest',
      -- 'folke/tokyonight.nvim',
      -- 'morhetz/gruvbox',
      -- 'sainnhe/gruvbox-material',
      -- 'AlexvZyl/nordic.nvim',
      -- 'doums/darcula',
      -- 'rktjmp/lush.nvim',
      -- 'ab-dx/ares.nvim',
    },
    lazy = false,
    priority = 1000,
    config = function()
      require('kanagawa').setup({
        compile = false,
        undercurl = true,
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = false,
        dimInactive = false,
        terminalColors = true,
        colors = {
          palette = {},
          theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
        },
        overrides = function(colors)
          local theme = colors.theme
          local makeDiagnosticColor = function(color)
            local c = require("kanagawa.lib.color")
            return { fg = color, bg = c(color):blend(theme.ui.bg, 0.95):to_hex() }
          end

          return {
            NormalFloat                = { bg = "none" },
            FloatBorder                = { bg = "none" },
            FloatTitle                 = { bg = "none" },
            NormalDark                 = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
            LazyNormal                 = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            MasonNormal                = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },

            -- TelescopeTitle = { fg = theme.ui.special, bold = true },
            -- TelescopePromptNormal = { bg = theme.ui.bg_p1 },
            -- TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
            -- TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
            -- TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
            -- TelescopePreviewNormal = { bg = theme.ui.bg_dim },
            -- TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },

            DiagnosticVirtualTextHint  = makeDiagnosticColor(theme.diag.hint),
            DiagnosticVirtualTextInfo  = makeDiagnosticColor(theme.diag.info),
            DiagnosticVirtualTextWarn  = makeDiagnosticColor(theme.diag.warning),
            DiagnosticVirtualTextError = makeDiagnosticColor(theme.diag.error),

            Pmenu                      = { fg = theme.ui.shade0, bg = theme.ui.bg_p1, blend = vim.o.pumblend },
            BlinkCmpMenuBorder         = { fg = theme.ui.shade0, bg = theme.ui.bg_p1, blend = vim.o.pumblend },
            PmenuSel                   = { fg = "NONE", bg = theme.ui.bg_m1 },
            PmenuSbar                  = { bg = theme.ui.bg_m1 },
            PmenuThumb                 = { bg = theme.ui.bg_p2 },
          }
        end,
        theme = "wave",
        background = {
          dark = "wave",
          light = "lotus"
        },
      })
      vim.cmd.colorscheme 'kanagawa'
      vim.cmd.hi 'Comment gui=none'
    end,
  },
}
