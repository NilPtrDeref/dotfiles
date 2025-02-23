vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.mouse = 'a'
vim.opt.showmode = false
-- vim.opt.clipboard = 'unnamedplus'
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
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = false
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.breakindent = true
vim.opt.wrap = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.autoread = true
vim.opt.number = false

vim.cmd 'autocmd FileType c setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab'
vim.cmd 'autocmd FileType h setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab'
vim.cmd 'autocmd FileType cpp setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab'
vim.cmd 'autocmd FileType hpp setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab'
vim.cmd 'autocmd FileType haskell setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab'
vim.cmd 'autocmd FileType javascript setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab'
vim.cmd 'autocmd FileType typescript setlocal tabstop=2 softtabstop=2 shiftwidth=2 noexpandtab'
vim.cmd 'autocmd FileType svelte setlocal tabstop=2 softtabstop=2 shiftwidth=2 noexpandtab'
vim.cmd 'autocmd FileType go setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab'

-- Set up templ
vim.filetype.add { extension = { templ = 'templ' } }
vim.cmd 'autocmd FileType templ setlocal tabstop=2 softtabstop=2 shiftwidth=2 noexpandtab'

-- Disable auto comment
vim.cmd 'autocmd BufEnter * set formatoptions-=cro'
vim.cmd 'autocmd BufEnter * setlocal formatoptions-=cro'

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('framework-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
