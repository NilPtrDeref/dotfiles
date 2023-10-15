require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = { "lua_ls", "gopls", "rust_analyzer" }
})

local on_attach = function(_, _)
	vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {})
	vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})
	vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, {})
	vim.keymap.set('n', '<leader>gi', vim.lsp.buf.implementation, {})
	vim.keymap.set('n', '<leader>gr', require('telescope.builtin').lsp_references, {})
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
end

require("cmp").setup({
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
    window = {
      completion = require("cmp").config.window.bordered(),
      documentation = require("cmp").config.window.bordered(),
    },
    mapping = require("cmp").mapping.preset.insert({
      ['<C-b>'] = require("cmp").mapping.scroll_docs(-4),
      ['<C-f>'] = require("cmp").mapping.scroll_docs(4),
      ['<C-Space>'] = require("cmp").mapping.complete(),
      ['<C-e>'] = require("cmp").mapping.abort(),
      ['<CR>'] = require("cmp").mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = require("cmp").config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  require("cmp").setup.filetype('gitcommit', {
    sources = require("cmp").config.sources({
      { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  require("cmp").setup.cmdline({ '/', '?' }, {
    mapping = require("cmp").mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  require("cmp").setup.cmdline(':', {
    mapping = require("cmp").mapping.preset.cmdline(),
    sources = require("cmp").config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

require("luasnip.loaders.from_vscode").lazy_load()

local capabilities = require('cmp_nvim_lsp').default_capabilities()
require("lspconfig").lua_ls.setup {
	on_attach = on_attach,
    capabilities = capabilities
}

require("lspconfig").gopls.setup {
	on_attach = on_attach,
    capabilities = capabilities
}

require("lspconfig").rust_analyzer.setup {
	on_attach = on_attach,
    capabilities = capabilities
}
