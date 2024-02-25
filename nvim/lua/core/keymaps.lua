-- Map leader to space
vim.g.mapleader = " "

-- Set directory viewer
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, {desc = "Go to file browser"})

-- Move text in visual
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected line down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected line up" })

-- Movement Utility
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join line below" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Move down half page" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Move up half page" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Move to next search match" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Move to previous search match" })

-- greatest remap ever: pasting over selected text, keeping register
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste over selected text" })

-- next greatest remap ever : asbjornHaland
-- Yank to system clipboard
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })

vim.keymap.set({"n", "v"}, "<leader>d", [["_d]], { desc = "Delete to black hole register" })

vim.keymap.set("n", "<leader>f=", vim.lsp.buf.format, { desc = "Format current file" })

-- Quickfix navigation
vim.keymap.set("n", "<leader>q", "<cmd>cclose<CR>", { desc = "Close quickfix" })
vim.keymap.set("n", "<leader>k", "<cmd>cnext<CR>zz", { desc = "Go to next quickfix" })
vim.keymap.set("n", "<leader>j", "<cmd>cprev<CR>zz", { desc = "Go to previous quickfix" })
vim.keymap.set("n", "<leader>h", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
vim.keymap.set("n", "<leader>l", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })

-- LSP
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gf", vim.lsp.buf.declaration, { desc = "Go to declaration" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
vim.keymap.set("n", "gt", vim.lsp.buf.references, { desc = "Go to references" })
vim.keymap.set("n", "gh", vim.lsp.buf.hover, { desc = "Show hover" })
vim.keymap.set("n", "gr", vim.lsp.buf.rename, { desc = "Rename" })
vim.keymap.set("n", "ga", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set("n", "gsh", vim.lsp.buf.signature_help, { desc = "Signature help" })
vim.keymap.set("n", "gsd", vim.lsp.buf.type_definition, { desc = "Type definition" })
vim.keymap.set("n", "gn", "<C-i>", { desc = "Goto next" })
vim.keymap.set("n", "gp", "<C-o>", { desc = "Goto previous" })

-- Find and replace in file
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Find and replace current word in file" })

-- Make current file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Reload vimrc
vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end, { desc = "Reload vimrc" })

-- Move between windows
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")
