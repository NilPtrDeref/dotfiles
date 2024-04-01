return {
  {
    'ThePrimeagen/harpoon',
    config = function()
      local mark = require 'harpoon.mark'
      local ui = require 'harpoon.ui'
      vim.keymap.set('n', '<leader>ha', mark.add_file, { desc = 'Add current file to harpoon' })
      vim.keymap.set('n', '<leader>hm', ui.toggle_quick_menu, { desc = 'Toggle quick menu' })
    end,
  },
}
