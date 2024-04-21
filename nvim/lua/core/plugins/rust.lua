return {
  { 'rust-lang/rust.vim' },
  {
    'mrcjkb/rustaceanvim',
    version = '^4',
    ft = { 'rust' },
    init = function()
      vim.g.rustaceanvim = {
        server = {
          on_attach = function()
            vim.keymap.set('n', '<leader>co', '<cmd>RustLsp openDocs<CR>', { desc = 'Open rust docs' })
            vim.keymap.set('n', '<leader>cd', '<cmd>RustLsp renderDiagnostic<CR>', { desc = 'Render rust diagnostic' })
          end,
          default_settings = {
            ['rust-analyzer'] = {
              -- cargo = {
              --   buildScripts = {
              --     enable = false,
              --   },
              -- },
              -- procMacro = {
              --   enable = false,
              -- },
              workspace = {
                symbol = {
                  search = {
                    kind = 'all_symbols',
                  },
                },
              },
            },
          },
        },
      }
    end,
    lazy = false,
  },
}
