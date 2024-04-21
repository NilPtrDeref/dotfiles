return {
  { 'rust-lang/rust.vim' },
  {
    'mrcjkb/rustaceanvim',
    version = '^4',
    ft = { 'rust' },
    config = function()
      vim.keymap.set('n', '<leader>co', '<cmd>RustLsp openDocs<CR>', { desc = 'Open rust docs' })
      vim.keymap.set('n', '<leader>cd', '<cmd>RustLsp renderDiagnostic<CR>', { desc = 'Render rust diagnostic' })
    end,
  },
}
