-- Clear search highlight
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })

-- Quickfix
vim.keymap.set('n', '<leader>qo', vim.diagnostic.setloclist, { desc = '[O]pen diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>qc', '<cmd>cclose<CR>', { desc = '[C]lose diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<A-N>', '<cmd>cnext<CR>', { desc = 'Go to next Quickfix' })
vim.keymap.set('n', '<A-P>', '<cmd>cprevious<CR>', { desc = 'Go to previous Quickfix' })

-- Split navigation
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<C-down>', '<C-w>-', { desc = 'Shrink window vertically' })
vim.keymap.set('n', '<C-up>', '<C-w>+', { desc = 'Grow window vertically' })
vim.keymap.set('n', '<C-left>', '<C-w><', { desc = 'Shrink window horizontally' })
vim.keymap.set('n', '<C-right>', '<C-w>>', { desc = 'Grow window horizontally' })

-- Movement
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Move down half page' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Move up half page' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Move to next search match' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Move to previous search match' })

-- Terminal
vim.keymap.set('t', '<C-q>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('t', '<C-h>', '<Cmd>wincmd h<CR>', { desc = 'Move focus to the left window' })
vim.keymap.set('t', '<C-l>', '<Cmd>wincmd l<CR>', { desc = 'Move focus to the right window' })
vim.keymap.set('t', '<C-j>', '<Cmd>wincmd j<CR>', { desc = 'Move focus to the lower window' })
vim.keymap.set('t', '<C-k>', '<Cmd>wincmd k<CR>', { desc = 'Move focus to the upper window' })


local function toggle_inlay()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end

-- LSP: Actions
vim.keymap.set('n', '<leader>lr', '<cmd>LspRestart<CR>', { silent = true, desc = '[L]sp [R]estart' })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = '[R]e[n]ame' })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = '[C]ode [A]ction' })
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Open [D]iagnostic In Hover' })
vim.keymap.set('n', '<leader>i', toggle_inlay, { desc = 'Toggle [I]nlay Hints' })

-- LSP: Hovers
vim.keymap.set('i', '<C-S>', vim.lsp.buf.signature_help, { desc = 'Signature Documentation' })
vim.keymap.set('n', '<C-S>', vim.lsp.buf.signature_help, { desc = 'Signature Documentation' })

-- LSP: Jumps
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = '[G]oto [D]efinition' })
vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, { desc = '[G]oto [T]ype Definition' })
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = '[G]oto [D]eclaration' })

-- LSP: Previews
vim.keymap.set('n', 'gpd', require('goto-preview').goto_preview_definition, { desc = '[G]oto [P]review [D]efinition' })
vim.keymap.set('n', 'gpr', require('goto-preview').goto_preview_references, { desc = '[G]oto [P]review [R]eferences' })
vim.keymap.set('n', 'gpt', require('goto-preview').goto_preview_type_definition,
  { desc = '[G]oto [P]review [T]ype Definition' })
vim.keymap.set('n', 'gpi', require('goto-preview').goto_preview_implementation,
  { desc = '[G]oto [P]review [I]mplementation' })
vim.keymap.set('n', 'gpD', require('goto-preview').goto_preview_declaration, { desc = '[G]oto [P]review [D]eclaration' })
vim.keymap.set('n', 'gP', require('goto-preview').close_all_win, { desc = 'Close All [P]reviews' })

-- LSP: Search
vim.keymap.set('n', '<leader>gd', require('telescope.builtin').lsp_definitions, { desc = '[G]et [D]efinition' })
vim.keymap.set('n', '<leader>gtd', require('telescope.builtin').lsp_type_definitions,
  { desc = '[G]et [T]ype [D]efinition' })
vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, { desc = '[G]et [R]eferences' })
vim.keymap.set('n', '<leader>ds', require('telescope.builtin').lsp_document_symbols, { desc = '[D]ocument [S]ymbols' })
vim.keymap.set('n', '<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols,
  { desc = '[W]orkspace [S]ymbols' })
vim.keymap.set('n', 'gi', require('telescope.builtin').lsp_implementations, { desc = '[G]et [I]mplementation' })
vim.keymap.set('n', 'gI', require('telescope.builtin').lsp_incoming_calls, { desc = '[G]et [I]ncoming Calls' })
vim.keymap.set('n', 'gO', require('telescope.builtin').lsp_outgoing_calls, { desc = '[G]et [O]utgoing Calls' })
