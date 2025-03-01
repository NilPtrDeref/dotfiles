return {
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      local Terminal = require('toggleterm.terminal').Terminal
      local fish = Terminal:new { cmd = 'fish', hidden = true, direction = 'float' }

      function _fish_toggle()
        fish:toggle(20)
      end

      vim.keymap.set('n', '<C-t>', '<cmd>lua _fish_toggle()<CR>', { desc = 'Open a terminal under the current window' })
      vim.keymap.set('t', '<C-t>', '<cmd>lua _fish_toggle()<CR>', { desc = 'Close a terminal under the current window' })
    end,
  },
}
