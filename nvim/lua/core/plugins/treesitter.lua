return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup {
        ensure_installed = {
          'go',
          'gomod',
          'gosum',
          'gowork',
          'gitignore',
          'rust',
          'bash',
          'comment',
          'dockerfile',
          'fish',
          'typescript',
          'c',
          'lua',
          'vim',
          'vimdoc',
          'query',
          'heex',
          'javascript',
          'html',
          'zig',
          'cpp',
          'svelte',
          'sql',
          'gotmpl',
        },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      }
    end,
  },
}
