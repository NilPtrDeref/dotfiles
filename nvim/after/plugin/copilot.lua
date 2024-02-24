-- Set copilot accept
vim.g.copilot_no_tab_map = true
vim.cmd("imap 'i' <C-y> copilot#Accept(\"\\<CR>\")")
