-- Clear search highlight
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })

-- Quickfix
vim.keymap.set('n', '<A-[>', '<cmd>cprevious<CR>', { desc = 'Go to previous [Q]uickfix' })
vim.keymap.set('n', '<A-]>', '<cmd>cnext<CR>', { desc = 'Go to next [Q]uickfix' })
vim.keymap.set('n', '<leader>qp', '<cmd>cprevious<CR>', { desc = 'Go to previous [Q]uickfix' })
vim.keymap.set('n', '<leader>qn', '<cmd>cnext<CR>', { desc = 'Go to next [Q]uickfix' })
vim.keymap.set('n', '<leader>qo', vim.diagnostic.setloclist, { desc = '[O]pen diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>qc', '<cmd>cclose<CR>', { desc = '[C]lose diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<A-j>', '<cmd>cnext<CR>', { desc = 'Go to next Quickfix' })
vim.keymap.set('n', '<A-k>', '<cmd>cprevious<CR>', { desc = 'Go to previous Quickfix' })

-- Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Split navigation
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<C-down>', '<C-w>-', { desc = 'Shrink window vertically' })
vim.keymap.set('n', '<C-up>', '<C-w>+', { desc = 'Grow window vertically' })

-- Set directory viewer (replaced by oil)
-- vim.keymap.set('n', '<leader>pv', vim.cmd.Ex, { desc = 'Go to file browser' })

-- Movement
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Move down half page' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Move up half page' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Move to next search match' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Move to previous search match' })

-- Terminal
vim.keymap.set('t', '<C-Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('t', '<C-h>', '<Cmd>wincmd h<CR>', { desc = 'Move focus to the left window' })
vim.keymap.set('t', '<C-l>', '<Cmd>wincmd l<CR>', { desc = 'Move focus to the right window' })
vim.keymap.set('t', '<C-j>', '<Cmd>wincmd j<CR>', { desc = 'Move focus to the lower window' })
vim.keymap.set('t', '<C-k>', '<Cmd>wincmd k<CR>', { desc = 'Move focus to the upper window' })
