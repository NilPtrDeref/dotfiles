return {
  {
    'stevearc/aerial.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('aerial').setup {
        on_attach = function(bufnr)
          vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
          vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
        end,
        layout = {
          max_width = { 40, 0.2 },
          min_width = 20,
          default_direction = 'prefer_left',
        },
        autojump = true,
        close_on_select = true,
      }
      -- vim.keymap.set('n', '<C-a>', '<cmd>AerialToggle<CR>')
    end,
  },
}
