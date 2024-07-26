return {
  {
    'nvimdev/lspsaga.nvim',
    config = function()
      require('lspsaga').setup {
        symbol_in_winbar = {
          enable = false,
        },
        lightbulb = {
          enable = false,
        },
        outline = {
          layout = 'float',
          close_after_jump = true,
          keys = {
            toggle_or_jump = '<CR>',
          },
        },
        finder = {
          max_height = 0.6,
          keys = {
            vsplit = 's',
            toggle_or_open = '<CR>',
          },
        },
        definition = {
          max_height = 0.6,
          keys = {
            vsplit = 's',
          },
        },
        callhierarchy = {
          max_height = 0.6,
          keys = {
            vsplit = 's',
            edit = '<CR>',
          },
        },
      }
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter', -- optional
      'nvim-tree/nvim-web-devicons',     -- optional
      'neovim/nvim-lspconfig',
    },
  },
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    opts = {},
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('framework-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          local opensig = function()
            local cmp = require 'cmp'
            cmp.close()
            vim.lsp.buf.signature_help()
          end
          vim.keymap.set('i', '<C-S>', opensig, { desc = 'Show signature help' })
          vim.keymap.set('n', '<leader>lr', '<cmd>LspRestart<CR>', { silent = true, desc = '[L]sp [R]estart' })

          local border = 'single'
          vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover,
            { border = border, max_width = 140, max_height = 30 })
          vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help,
            { border = border, max_width = 140, max_height = 30 })
          vim.diagnostic.config { float = { border = border } }
          require('lspconfig.ui.windows').default_options = { border = border }

          -- Jumps
          map('gd', '<cmd>Lspsaga goto_definition<CR>', '[G]oto [D]efinition')
          map('gtd', '<cmd>Lspsaga goto_type_definition<CR>', '[G]oto [T]ype definition')
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('<leader>cD', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
          map('gr', '<cmd>Lspsaga finder tyd+ref+imp+def<CR>', '[G]oto [R]eferences')
          map('gi', '<cmd>Lspsaga incoming_calls<CR>', '[G]oto [I]ncoming Calls')
          map('go', '<cmd>Lspsaga outgoing_calls<CR>', '[G]oto [O]utgoing Calls')
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          -- Search
          map('<leader>wds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          -- map('<C-a>', '<cmd>Lspsaga outline<CR>', 'Toggle Outline')

          -- Actions
          map('<leader>rn', '<cmd>Lspsaga rename<CR>', '[R]e[n]ame')
          map('<leader>rl', '<cmd>LspRestart<CR>', '[R]estart [L]SP')

          -- Hovers
          map('<leader>ca', '<cmd>Lspsaga code_action<CR>', '[C]ode [A]ction')
          map('<leader>cd', '<cmd>Lspsaga peek_definition<CR>', '[C]ode [D]efinition')
          map('<leader>ct', '<cmd>Lspsaga peek_type_definition<CR>', '[C]ode [T]ype definition')
          map('K', '<cmd>Lspsaga hover_doc<CR>', 'Hover Documentation')
          map('<C-S>', vim.lsp.buf.signature_help, 'Signature Documentation')
          map('<leader>d', vim.diagnostic.open_float, 'Open diagnostic in hover')

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      local ensure_installed = {
        'clangd',
        'gopls',
        'tsserver',
        'svelte',
        'html',
        'htmx',
        'tailwindcss',
        'lua_ls',
        'cssls',
        'eslint',
        'templ',
      }
      require('mason').setup { ensure_installed = ensure_installed }
      require('mason-lspconfig').setup { ensure_installed = ensure_installed }

      local lsp = require 'lspconfig'
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
      local on_attach = function(client, bufnr) end

      local disable_templ_capabilities = function(client)
        local disable_ft = { "templ" } -- add your filetypes here
        if vim.tbl_contains(disable_ft, vim.bo.filetype) then
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
          client.server_capabilities.documentHighlightProvider = false
        end
      end

      local no_templ_on_attach = function(client, bufnr)
        disable_templ_capabilities(client)
      end

      lsp.templ.setup {
        on_attach = on_attach,
        capabilities = capabilities,
      }
      lsp.gopls.setup {
        capabilities = capabilities,
        on_attach = no_templ_on_attach,
      }
      lsp.clangd.setup {
        on_attach = on_attach,
        capabilities = capabilities,
      }
      lsp.tsserver.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        root_dir = require('lspconfig.util').root_pattern '.git',
      }
      lsp.eslint.setup {
        on_attach = on_attach,
        capabilities = capabilities,
      }
      lsp.svelte.setup {
        on_attach = on_attach,
        capabilities = capabilities,
      }
      lsp.zls.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = { 'zls' },
      }
      lsp.html.setup {
        on_attach = no_templ_on_attach,
        capabilities = capabilities,
        filetypes = { 'html', 'templ', 'javascript', 'typescript' },
      }
      lsp.cssls.setup {
        on_attach = no_templ_on_attach,
        capabilities = capabilities,
        filetypes = { 'css', 'html', 'templ' },
      }
      lsp.htmx.setup {
        on_attach = no_templ_on_attach,
        capabilities = capabilities,
        filetypes = { 'html' },
      }
      lsp.tailwindcss.setup {
        on_attach = no_templ_on_attach,
        capabilities = capabilities,
        filetypes = { 'html', 'templ', 'svelte', 'javascript', 'typescript' },
        init_options = { userLanguages = { templ = 'html' } },
      }
      lsp.lua_ls.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT' },
            workspace = {
              checkThirdParty = false,
              library = {
                '${3rd}/luv/library',
                unpack(vim.api.nvim_get_runtime_file('', true)),
              },
            },
            completion = {
              callSnippet = 'Replace',
            },
          },
        },
      }
    end,
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    version = 'v5.7.0',
    opts = {
      notify_on_error = false,
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
      formatters_by_ft = {
        -- lua = { 'stylua' },
        c = { 'clang-format' },
        h = { 'clang-format' },
        javascript = { 'prettier' },
        typescript = { 'prettier' },
        svelte = { 'prettier' },
      },
      formatters = {
        clang_format = {
          args = { '-style=webkit' },
        },
      },
    },
  },
}
