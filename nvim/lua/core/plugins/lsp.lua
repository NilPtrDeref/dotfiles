return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'saghen/blink.cmp',
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
    },

    config = function()
      local lspconfig = require('lspconfig')
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      local ensure_installed = {
        'clangd',
        'gopls',
        'ts_ls',
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
      require('mason-lspconfig').setup {
        ensure_installed = ensure_installed,
        automatic_installation = true,
      }

      local on_attach = function(client, bufnr)
        if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
          -- Enable inlay hints by default
          vim.lsp.inlay_hint.enable(true, { bufnr })
        end
      end
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
        on_attach(client, bufnr)
      end

      lspconfig.templ.setup {
        on_attach = on_attach,
        capabilities = capabilities,
      }
      lspconfig.gopls.setup {
        capabilities = capabilities,
        on_attach = no_templ_on_attach,
        settings = {
          gopls = {
            gofumpt = true,
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
            analyses = {
              nilness = true,
              unusedparams = true,
              unusedwrite = true,
              unusedfunc = true,
              useany = true,
            },
            completeUnimported = true,
            staticcheck = true,
          },
        },
      }
      lspconfig.clangd.setup {
        on_attach = on_attach,
        capabilities = capabilities,
      }
      lspconfig.ts_ls.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        root_dir = require('lspconfig.util').root_pattern '.git',
      }
      lspconfig.eslint.setup {
        on_attach = on_attach,
        capabilities = capabilities,
      }
      lspconfig.svelte.setup {
        on_attach = on_attach,
        capabilities = capabilities,
      }
      lspconfig.zls.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = { 'zls' },
        filetypes = { 'zig', 'zir' },
        root_dir = require('lspconfig.util').root_pattern('build.zig', '.git'),
        settings = {
          zls = {
            enable_build_on_save = true,
          },
        },
      }
      lspconfig.html.setup {
        on_attach = no_templ_on_attach,
        capabilities = capabilities,
        filetypes = { 'html', 'templ', 'javascript', 'typescript' },
      }
      lspconfig.cssls.setup {
        on_attach = no_templ_on_attach,
        capabilities = capabilities,
        filetypes = { 'css', 'html', 'templ' },
      }
      lspconfig.htmx.setup {
        on_attach = no_templ_on_attach,
        capabilities = capabilities,
        filetypes = { 'html' },
      }
      lspconfig.tailwindcss.setup {
        on_attach = no_templ_on_attach,
        capabilities = capabilities,
        filetypes = { 'html', 'templ', 'svelte', 'javascript', 'typescript' },
        init_options = { userLanguages = { templ = 'html' } },
      }
      lspconfig.lua_ls.setup {
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

      local border = 'single'
      vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover,
        { border = border, max_width = 140, max_height = 30 })
      vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help,
        { border = border, max_width = 140, max_height = 30 })
      vim.diagnostic.config { float = { border = border } }
      require('lspconfig.ui.windows').default_options = { border = border }

      -- -- Autohighlight hovered word
      -- vim.api.nvim_create_autocmd('LspAttach', {
      --   group = vim.api.nvim_create_augroup('framework-lsp-attach', { clear = true }),
      --   callback = function(event)
      --     local client = vim.lsp.get_client_by_id(event.data.client_id)
      --     if client and client.server_capabilities.documentHighlightProvider then
      --       vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      --         buffer = event.buf,
      --         callback = vim.lsp.buf.document_highlight,
      --       })
      --
      --       vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
      --         buffer = event.buf,
      --         callback = vim.lsp.buf.clear_references,
      --       })
      --     end
      --   end
      -- })
    end
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
