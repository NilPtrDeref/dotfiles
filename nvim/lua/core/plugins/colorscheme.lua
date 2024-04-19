return {
  {
    'sainnhe/everforest',
    dependencies = {
      'catppuccin/nvim',
      'folke/tokyonight.nvim',
      'rose-pine/neovim',
      'rebelot/kanagawa.nvim',
      'morhetz/gruvbox',
      'EdenEast/nightfox.nvim',
      'sainnhe/gruvbox-material',
      'sainnhe/sonokai',
      'AlexvZyl/nordic.nvim',
      'doums/darcula',
    },
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'everforest'
      vim.cmd.hi 'Comment gui=none'
    end,
  },
}
