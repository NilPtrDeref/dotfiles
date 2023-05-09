---@type ChadrcConfig 

vim.cmd('set formatoptions-=cro')
vim.wo.relativenumber = true

 local M = {}
 M.ui = {theme = 'catppuccin'}
 M.plugins = 'custom.plugins'
 M.mappings = require 'custom.mappings'
 return M
