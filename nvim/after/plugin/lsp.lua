vim.filetype.add({
    extension = {
        templ = "templ",
    },
})

local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
	-- see :help lsp-zero-keybindings
	-- to learn the available actions
	lsp_zero.default_keymaps({buffer = bufnr})
end)

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {
	'gopls',
	'rust_analyzer',
	'lua_ls',
	'eslint',
	'templ',
	'zls',
	'clangd'
  },
  handlers = {
    lsp_zero.default_setup,
  },
})


local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local mapping = {
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
  ['<Tab>'] = cmp.mapping.confirm({select = true}),
  ['<C-Space>'] = cmp.mapping.complete(),
}

cmp.setup({
	completion = {
		completeopt = 'noselect',
	},
	preselect = cmp.PreselectMode.None,
	sources = {
		{name = "copilot", group_index = 2},
		{name = "nvim_lsp", group_index = 2},
		{name = "path", group_index = 2},
		{name = "luasnip", group_index = 2},
	},
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
	mapping = mapping,
})

lsp_zero.set_preferences({
	sign_icons = {}
})
