return {
  {
    'echasnovski/mini.nvim',
    version = 'v0.12.0',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      local statusline = require 'mini.statusline'
      statusline.setup()

      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      require('mini.move').setup({
        mappings = {
          left = '<M-H>',
          right = '<M-L>',
          down = '<M-J>',
          up = '<M-K>',
          line_left = '<M-H>',
          line_right = '<M-L>',
          line_down = '<M-J>',
          line_up = '<M-K>',
        },
      })

      require('mini.splitjoin').setup()
    end,
  },
}
