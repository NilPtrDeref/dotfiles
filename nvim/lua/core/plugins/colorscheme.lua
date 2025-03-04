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
          return {}
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
