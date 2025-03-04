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
        transparent = true,
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
            NormalFloat                 = { bg = "NONE", blend = vim.o.pumblend },
            FloatBorder                 = { bg = "NONE", blend = vim.o.pumblend },
            FloatTitle                  = { bg = "NONE", blend = vim.o.pumblend },
            NormalDark                  = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
            LazyNormal                  = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            MasonNormal                 = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            LineNr                      = { bg = "NONE", blend = vim.o.pumblend },
            CursorLine                  = { bg = theme.ui.shade0 },
            CursorLineNr                = { fg = colors.palette.carpYellow, bg = "NONE", blend = vim.o.pumblend },
            SignColumn                  = { bg = "NONE", blend = vim.o.pumblend },
            GitSignsAdd                 = { bg = "NONE", blend = vim.o.pumblend },
            GitSignsChange              = { bg = "NONE", blend = vim.o.pumblend },
            GitSignsDelete              = { bg = "NONE", blend = vim.o.pumblend },

            TelescopeTitle              = { fg = colors.palette.carpYellow, bold = true },
            TelescopePromptNormal       = { bg = "NONE", blend = vim.o.pumblend },
            TelescopePromptBorder       = { fg = colors.palette.autumnGreen, bg = "NONE", blend = vim.o.pumblend },
            TelescopeResultsNormal      = { fg = colors.palette.fujiWhite, bg = "NONE", blend = vim.o.pumblend },
            TelescopeResultsBorder      = { fg = colors.palette.autumnGreen, bg = "NONE", blend = vim.o.pumblend },
            TelescopePreviewNormal      = { bg = "NONE", blend = vim.o.pumblend },
            TelescopePreviewBorder      = { fg = colors.palette.autumnGreen, bg = "NONE", blend = vim.o.pumblend },

            DiagnosticVirtualTextHint   = makeDiagnosticColor(theme.diag.hint),
            DiagnosticVirtualTextInfo   = makeDiagnosticColor(theme.diag.info),
            DiagnosticVirtualTextWarn   = makeDiagnosticColor(theme.diag.warning),
            DiagnosticVirtualTextError  = makeDiagnosticColor(theme.diag.error),
            DiagnosticSignHint          = { bg = "NONE", blend = vim.o.pumblend },
            DiagnosticSignInfo          = { bg = "NONE", blend = vim.o.pumblend },
            DiagnosticSignWarn          = { bg = "NONE", blend = vim.o.pumblend },
            DiagnosticSignError         = { bg = "NONE", blend = vim.o.pumblend },

            BlinkCmpMenu                = { fg = theme.ui.fg_dim, bg = "NONE", blend = vim.o.pumblend },
            BlinkCmpMenuBorder          = { fg = colors.palette.carpYellow, bg = "NONE", blend = vim.o.pumblend },
            BlinkCmpMenuSelection       = { fg = colors.palette.roninYellow, bg = theme.ui.bg_p1 },
            BlinkCmpKind                = { fg = colors.palette.roninYellow },
            BlinkCmpDoc                 = { fg = theme.ui.fg_dim, bg = "NONE", blend = vim.o.pumblend },
            BlinkCmpDocBorder           = { fg = colors.palette.carpYellow, bg = "NONE", blend = vim.o.pumblend },
            BlinkCmpDocSeparator        = { fg = colors.palette.carpYellow, bg = "NONE", blend = vim.o.pumblend },
            BlinkCmpSignatureHelp       = { fg = theme.ui.fg_dim, bg = "NONE", blend = vim.o.pumblend },
            BlinkCmpSignatureHelpBorder = { fg = colors.palette.carpYellow, bg = "NONE", blend = vim.o.pumblend },
            Pmenu                       = { fg = theme.ui.shade0, bg = "NONE", blend = vim.o.pumblend },
            PmenuSel                    = { fg = "NONE", bg = theme.ui.bg_p2 },
            PmenuSbar                   = { bg = theme.ui.bg_m1 },
            PmenuThumb                  = { bg = colors.palette.roninYellow },

            RenderMarkdownCode          = { bg = "NONE", blend = vim.o.pumblend },
            ColorColumn                 = { bg = "NONE", blend = vim.o.pumblend },
            RenderMarkdownCodeInline    = { bg = "NONE", blend = vim.o.pumblend },
            mkdLineBreak                = { bg = "NONE", blend = vim.o.pumblend },
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
