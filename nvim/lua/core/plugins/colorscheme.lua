return {
  {
    'Shatur/neovim-ayu',
    dependencies = {
      -- 'jake-wilcox/afterglow.nvim',
      -- 'catppuccin/nvim',
      -- 'rose-pine/neovim',
      -- 'rebelot/kanagawa.nvim',
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
      require('ayu').setup({
        mirage = false,
        terminal = true,
        overrides = {},
      })
      vim.cmd.colorscheme 'ayu-dark'
      vim.cmd.hi 'Comment gui=none'
    end,
  },
}
