return {
  {
    'stevearc/nightfox.nvim',
    dependencies = {
      'sainnhe/sonokai',
      'sainnhe/everforest',
      'catppuccin/nvim',
      'folke/tokyonight.nvim',
      'rose-pine/neovim',
      'rebelot/kanagawa.nvim',
      'morhetz/gruvbox',
      'sainnhe/gruvbox-material',
      'AlexvZyl/nordic.nvim',
      'doums/darcula',
      'rktjmp/lush.nvim',
      'ab-dx/ares.nvim',
    },
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'ares'
      -- vim.opt.background = 'light'
      vim.cmd.hi 'Comment gui=none'
    end,
  },
}
