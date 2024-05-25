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
    end,
  },
}
