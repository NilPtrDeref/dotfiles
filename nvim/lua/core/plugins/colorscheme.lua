return {
  {
    'sainnhe/everforest',
    dependencies = {
      'catppuccin/nvim',
      'folke/tokyonight.nvim',
      'rose-pine/neovim',
      'rebelot/kanagawa.nvim',
    },
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'rose-pine'
      vim.cmd.hi 'Comment gui=none'
    end,
  },
}
