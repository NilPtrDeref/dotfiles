return {
  {
    'rose-pine/neovim',
    dependencies = {
      -- 'rebelot/kanagawa.nvim',
      -- 'stevearc/nightfox.nvim',
      -- 'sainnhe/sonokai',
      -- 'sainnhe/everforest',
      -- 'catppuccin/nvim',
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
      vim.cmd.colorscheme 'rose-pine'
      vim.cmd.hi 'Comment gui=none'
    end,
  },
}
