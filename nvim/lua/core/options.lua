vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.opt.clipboard = 'unnamedplus'
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.hlsearch = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false
vim.opt.smartindent = true

vim.cmd 'autocmd FileType c setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab'
vim.cmd 'autocmd FileType h setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab'
vim.cmd 'autocmd FileType cpp setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab'
vim.cmd 'autocmd FileType hpp setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab'
vim.cmd 'autocmd FileType haskell setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab'
vim.cmd 'autocmd FileType javascript setlocal tabstop=2 softtabstop=2 shiftwidth=2 noexpandtab'
vim.cmd 'autocmd FileType typescript setlocal tabstop=2 softtabstop=2 shiftwidth=2 noexpandtab'
vim.cmd 'autocmd FileType svelte setlocal tabstop=2 softtabstop=2 shiftwidth=2 noexpandtab'

vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false

-- Disable auto comment
vim.cmd 'autocmd BufEnter * set formatoptions-=cro'
vim.cmd 'autocmd BufEnter * setlocal formatoptions-=cro'

-- Set h files a c filetype so clangd works in them
-- vim.g.c_syntax_for_h = true

-- Set up templ
vim.filetype.add { extension = { templ = 'templ' } }

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('framework-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
