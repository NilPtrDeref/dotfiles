-- Neovim configuration (single file)
--
-- Sections:
--   1. Options & autocmds
--   2. Plugin manager bootstrap (lazy.nvim)
--   3. Plugins
--   4. Keymaps

----------------------------------------------------------------------
-- 1. Options & autocmds
----------------------------------------------------------------------
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
vim.opt.wrap = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.autoread = true
vim.opt.confirm = true -- ask to save instead of erroring on :q, :e, etc. with unsaved changes
vim.opt.winborder = 'rounded' -- default border for floating windows that don't set one

-- Set up templ
vim.filetype.add { extension = { templ = 'templ' } }

-- Per-filetype indentation: { tabstop/softtabstop/shiftwidth, expandtab }
local indent_by_ft = {
  c = { 4, true },
  h = { 4, true },
  cpp = { 4, true },
  hpp = { 4, true },
  haskell = { 2, true },
  javascript = { 2, true },
  typescript = { 2, false },
  svelte = { 2, false },
  go = { 4, false },
  html = { 4, false },
  templ = { 2, false },
  python = { 4, true },
}

for ft, indent in pairs(indent_by_ft) do
  vim.api.nvim_create_autocmd('FileType', {
    pattern = ft,
    callback = function()
      vim.opt_local.tabstop = indent[1]
      vim.opt_local.softtabstop = indent[1]
      vim.opt_local.shiftwidth = indent[1]
      vim.opt_local.expandtab = indent[2]
    end,
  })
end

-- Disable auto comment
vim.api.nvim_create_autocmd('BufEnter', {
  desc = 'Disable automatic comment continuation',
  callback = function()
    vim.opt.formatoptions:remove { 'c', 'r', 'o' }
  end,
})

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('framework-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Filetype-aware :make
-- When the current directory has no Makefile, `:make` runs a build command that suits
-- the buffer's filetype (using the matching `:compiler` for its errorformat so errors land
-- in the quickfix list). With a Makefile present, plain `make` is used.
local function has_makefile()
  for _, name in ipairs { 'Makefile', 'makefile', 'GNUmakefile' } do
    if (vim.uv or vim.loop).fs_stat(name) then
      return true
    end
  end
  return false
end

-- Use `npm run build` when package.json defines one, otherwise `fallback` (may be nil)
local function npm_build_or(fallback)
  return function()
    local ok, pkg = pcall(function()
      return vim.json.decode(table.concat(vim.fn.readfile 'package.json', '\n'))
    end)
    if ok and type(pkg) == 'table' and type(pkg.scripts) == 'table' and pkg.scripts.build then
      return 'npm run build'
    end
    return fallback
  end
end

-- prg: string, or function returning a string/nil. %:S / %:r:S are expanded by :make.
local make_by_ft = {
  go = { compiler = 'go', prg = 'go build .' },
  zig = { compiler = 'zig_build', prg = 'zig build' },
  rust = { compiler = 'cargo', prg = 'cargo build' },
  c = { compiler = 'gcc', prg = 'gcc -Wall -Wextra -g %:S -o %:r:S' },
  cpp = { compiler = 'gcc', prg = 'g++ -std=c++20 -Wall -Wextra -g %:S -o %:r:S' },
  python = { compiler = 'pyunit', prg = 'python3 -m py_compile %:S' },
  typescript = { compiler = 'tsc', prg = npm_build_or 'npx --no tsc --noEmit --pretty false' },
  javascript = { compiler = 'tsc', prg = npm_build_or(nil) },
  svelte = { compiler = 'tsc', prg = npm_build_or(nil) },
  templ = { prg = 'templ generate' },
  odin = { prg = 'odin build .', efm = '%f(%l:%c) %m' },
}

vim.api.nvim_create_autocmd('QuickFixCmdPre', {
  desc = 'Pick a filetype-appropriate makeprg when there is no Makefile',
  group = vim.api.nvim_create_augroup('filetype-make', { clear = true }),
  pattern = { 'make', 'lmake' },
  callback = function()
    local spec = make_by_ft[vim.bo.filetype]
    if not spec then
      return
    end

    -- Makefile present (or nothing suitable for this project): plain `make`
    local prg
    if not has_makefile() then
      prg = spec.prg
      if type(prg) == 'function' then
        prg = prg()
      end
    end
    if not prg then
      pcall(vim.cmd.compiler, 'make')
      return
    end

    if spec.compiler then
      pcall(vim.cmd.compiler, spec.compiler)
    end
    if spec.efm then
      vim.bo.errorformat = spec.efm
    end
    vim.bo.makeprg = prg
  end,
})

----------------------------------------------------------------------
-- 2. Plugin manager bootstrap (lazy.nvim)
----------------------------------------------------------------------
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end
vim.opt.rtp:prepend(lazypath)

----------------------------------------------------------------------
-- 3. Plugins
----------------------------------------------------------------------
require('lazy').setup({
  'tpope/vim-sleuth',
  { 'windwp/nvim-autopairs',          event = 'InsertEnter', config = true },

  ------------------------------------------------------------------
  -- Colorscheme
  ------------------------------------------------------------------
  {
    'rebelot/kanagawa.nvim',
    dependencies = {
      -- 'Shatur/neovim-ayu',
      -- 'jake-wilcox/afterglow.nvim',
      -- 'catppuccin/nvim',
      -- 'rose-pine/neovim',
      -- 'stevearc/nightfox.nvim',
      -- 'sainnhe/sonokai',
      -- 'sainnhe/everforest',
      -- 'folke/tokyonight.nvim',
      -- 'morhetz/gruvbox',
      -- 'sainnhe/gruvbox-material',
      -- 'AlexvZyl/nordic.nvim',
      -- 'doums/darcula',
      -- 'rktjmp/lush.nvim',
      -- 'ab-dx/ares.nvim',
    },
    lazy = false,
    priority = 1000,
    config = function()
      require('kanagawa').setup {
        compile = false,
        undercurl = true,
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = true,
        dimInactive = false,
        terminalColors = true,
        colors = {
          palette = {},
          theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
        },
        overrides = function(colors)
          local theme = colors.theme
          local makeDiagnosticColor = function(color)
            local c = require 'kanagawa.lib.color'
            return { fg = color, bg = c(color):blend(theme.ui.bg, 0.95):to_hex() }
          end

          return {
            NormalFloat = { bg = 'NONE', blend = vim.o.pumblend },
            FloatBorder = { bg = 'NONE', blend = vim.o.pumblend },
            FloatTitle = { bg = 'NONE', blend = vim.o.pumblend },
            NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
            LazyNormal = { fg = theme.ui.fg_dim, bg = 'NONE', blend = vim.o.pumblend },
            MasonNormal = { fg = theme.ui.fg_dim, bg = 'NONE', blend = vim.o.pumblend },
            LineNr = { bg = 'NONE', blend = vim.o.pumblend },
            CursorLine = { bg = theme.ui.shade0 },
            CursorLineNr = { fg = colors.palette.carpYellow, bg = 'NONE', blend = vim.o.pumblend },
            SignColumn = { bg = 'NONE', blend = vim.o.pumblend },
            GitSignsAdd = { bg = 'NONE', blend = vim.o.pumblend },
            GitSignsChange = { bg = 'NONE', blend = vim.o.pumblend },
            GitSignsDelete = { bg = 'NONE', blend = vim.o.pumblend },

            TelescopeTitle = { fg = colors.palette.carpYellow, bold = true },
            TelescopePromptNormal = { bg = 'NONE', blend = vim.o.pumblend },
            TelescopePromptBorder = { fg = colors.palette.autumnGreen, bg = 'NONE', blend = vim.o.pumblend },
            TelescopeResultsNormal = { fg = colors.palette.fujiWhite, bg = 'NONE', blend = vim.o.pumblend },
            TelescopeResultsBorder = { fg = colors.palette.autumnGreen, bg = 'NONE', blend = vim.o.pumblend },
            TelescopePreviewNormal = { bg = 'NONE', blend = vim.o.pumblend },
            TelescopePreviewBorder = { fg = colors.palette.autumnGreen, bg = 'NONE', blend = vim.o.pumblend },

            DiagnosticVirtualTextHint = makeDiagnosticColor(theme.diag.hint),
            DiagnosticVirtualTextInfo = makeDiagnosticColor(theme.diag.info),
            DiagnosticVirtualTextWarn = makeDiagnosticColor(theme.diag.warning),
            DiagnosticVirtualTextError = makeDiagnosticColor(theme.diag.error),
            DiagnosticSignHint = { bg = 'NONE', blend = vim.o.pumblend },
            DiagnosticSignInfo = { bg = 'NONE', blend = vim.o.pumblend },
            DiagnosticSignWarn = { bg = 'NONE', blend = vim.o.pumblend },
            DiagnosticSignError = { bg = 'NONE', blend = vim.o.pumblend },

            BlinkCmpMenu = { fg = theme.ui.fg_dim, bg = 'NONE', blend = vim.o.pumblend },
            BlinkCmpMenuBorder = { fg = colors.palette.carpYellow, bg = 'NONE', blend = vim.o.pumblend },
            BlinkCmpMenuSelection = { fg = colors.palette.roninYellow, bg = theme.ui.bg_p1 },
            BlinkCmpKind = { fg = colors.palette.roninYellow },
            BlinkCmpDoc = { fg = theme.ui.fg_dim, bg = 'NONE', blend = vim.o.pumblend },
            BlinkCmpDocBorder = { fg = colors.palette.carpYellow, bg = 'NONE', blend = vim.o.pumblend },
            BlinkCmpDocSeparator = { fg = colors.palette.carpYellow, bg = 'NONE', blend = vim.o.pumblend },
            BlinkCmpSignatureHelp = { fg = theme.ui.fg_dim, bg = 'NONE', blend = vim.o.pumblend },
            BlinkCmpSignatureHelpBorder = { fg = colors.palette.carpYellow, bg = 'NONE', blend = vim.o.pumblend },
            Pmenu = { fg = theme.ui.pmenu.fg, bg = 'NONE', blend = vim.o.pumblend },
            PmenuSel = { fg = 'NONE', bg = theme.ui.bg_p2 },
            PmenuSbar = { bg = theme.ui.bg_m1 },
            PmenuThumb = { bg = colors.palette.roninYellow },
            -- Keep the popup menu's extra columns in line with Pmenu/PmenuSel
            PmenuKind = { bg = 'NONE', blend = vim.o.pumblend },
            PmenuExtra = { bg = 'NONE', blend = vim.o.pumblend },
            PmenuKindSel = { bg = theme.ui.bg_p2 },
            PmenuExtraSel = { bg = theme.ui.bg_p2 },
            BlinkCmpScrollBarGutter = { bg = 'NONE', blend = vim.o.pumblend },

            -- Noice confirm popup ("Save changes?"): its choice buttons linked to opaque CursorLine/Visual
            NoiceConfirm = { bg = 'NONE', blend = vim.o.pumblend },
            NoiceFormatConfirm = { fg = theme.ui.fg_dim, bg = 'NONE', blend = vim.o.pumblend },
            NoiceFormatConfirmDefault = { fg = colors.palette.carpYellow, bg = 'NONE', bold = true, blend = vim.o.pumblend },

            -- Tabline (mini.tabline): transparent, with the current buffer subtly highlighted
            TabLine = { fg = theme.ui.special, bg = 'NONE', blend = vim.o.pumblend },
            TabLineFill = { bg = 'NONE', blend = vim.o.pumblend },
            TabLineSel = { fg = theme.ui.fg, bg = theme.ui.bg_p1, bold = true },
            MiniTablineFill = { bg = 'NONE', blend = vim.o.pumblend },
            -- Hidden tabs were nearly unreadable (contrast 2.6); Visible was bold like Current
            MiniTablineHidden = { fg = theme.ui.special, bg = 'NONE', blend = vim.o.pumblend },
            MiniTablineVisible = { fg = theme.ui.fg_dim, bg = 'NONE', bold = false, blend = vim.o.pumblend },
            MiniTablineCurrent = { fg = theme.ui.fg, bg = theme.ui.bg_p1, bold = true, underline = true, sp = colors.palette.crystalBlue },
            MiniTablineModifiedHidden = { fg = colors.palette.carpYellow, bg = 'NONE', blend = vim.o.pumblend },
            MiniTablineModifiedVisible = { fg = colors.palette.carpYellow, bg = 'NONE', blend = vim.o.pumblend },
            MiniTablineModifiedCurrent = { fg = colors.palette.carpYellow, bg = theme.ui.bg_p1, bold = true, underline = true, sp = colors.palette.crystalBlue },

            -- Other groups that kept an opaque background
            TelescopeBorder = { bg = 'NONE', blend = vim.o.pumblend },
            FloatFooter = { bg = 'NONE', blend = vim.o.pumblend },
            MsgSeparator = { bg = 'NONE', blend = vim.o.pumblend },
            FoldColumn = { bg = 'NONE', blend = vim.o.pumblend },
            CursorLineFold = { bg = 'NONE', blend = vim.o.pumblend },
            StatusLine = { bg = 'NONE', blend = vim.o.pumblend },
            StatusLineNC = { bg = 'NONE', blend = vim.o.pumblend },
            MiniStatuslineFilename = { bg = 'NONE', blend = vim.o.pumblend },
            -- Overriding the link dropped its text colour, so inactive windows looked active
            MiniStatuslineInactive = { fg = theme.ui.special, bg = 'NONE', blend = vim.o.pumblend },

            RenderMarkdownCode = { bg = 'NONE', blend = vim.o.pumblend },
            ColorColumn = { bg = 'NONE', blend = vim.o.pumblend },
            RenderMarkdownCodeInline = { bg = 'NONE', blend = vim.o.pumblend },
            mkdLineBreak = { bg = 'NONE', blend = vim.o.pumblend },
          }
        end,
        theme = 'wave',
        background = {
          dark = 'wave',
          light = 'lotus',
        },
      }
      vim.cmd.colorscheme 'kanagawa'
      vim.cmd.hi 'Comment gui=none'
    end,
  },

  ------------------------------------------------------------------
  -- Completion (blink.cmp)
  -- NOTE: previously split across autocomplete.lua and blink.lua, which
  -- lazy.nvim merged. This is the merged result (blink.lua values won
  -- on conflicts: version, borders, doc/menu sizes).
  ------------------------------------------------------------------
  {
    'saghen/blink.cmp',
    dependencies = {
      'rafamadriz/friendly-snippets',
      'giuxtaposition/blink-cmp-copilot',
    },
    -- use a release tag to download pre-built binaries
    version = '1.*',
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      sources = {
        default = { 'lsp', 'snippets', 'path', 'copilot', 'buffer' },
        providers = {
          lsp = {
            name = 'lsp',
            enabled = true,
            module = 'blink.cmp.sources.lsp',
            score_offset = 1000,
            fallbacks = { 'buffer' },
          },
          snippets = {
            name = 'snippets',
            enabled = true,
            module = 'blink.cmp.sources.snippets',
            score_offset = 950,
            max_items = 5,
            fallbacks = { 'buffer' },
          },
          path = {
            name = 'path',
            enabled = true,
            module = 'blink.cmp.sources.path',
            score_offset = 900,
            max_items = 3,
            fallbacks = { 'buffer' },
          },
          copilot = {
            name = 'copilot',
            enabled = true,
            module = 'blink-cmp-copilot',
            score_offset = 800,
            async = true,
            fallbacks = { 'buffer' },
            transform_items = function(_, items)
              local CompletionItemKind = require('blink.cmp.types').CompletionItemKind
              local kind_idx = #CompletionItemKind + 1
              CompletionItemKind[kind_idx] = 'Copilot'
              for _, item in ipairs(items) do
                item.kind = kind_idx
              end
              return items
            end,
          },
          buffer = {
            name = 'buffer',
            enabled = true,
            module = 'blink.cmp.sources.buffer',
            score_offset = 800,
            max_items = 3,
            min_keyword_length = 4,
          },
        },
      },
      keymap = {
        preset = 'default',
        ['<C-l>'] = { 'snippet_forward', 'fallback' },
        ['<C-h>'] = { 'snippet_backward', 'fallback' },
      },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono',
        kind_icons = {
          Copilot = '',
          Text = '󰉿',
          Method = '󰊕',
          Function = '󰊕',
          Constructor = '󰒓',

          Field = '󰜢',
          Variable = '󰆦',
          Property = '󰖷',

          Class = '󱡠',
          Interface = '󱡠',
          Struct = '󱡠',
          Module = '󰅩',

          Unit = '󰪚',
          Value = '󰦨',
          Enum = '󰦨',
          EnumMember = '󰦨',

          Keyword = '󰻾',
          Constant = '󰏿',

          Snippet = '󱄽',
          Color = '󰏘',
          File = '󰈔',
          Reference = '󰬲',
          Folder = '󰉋',
          Event = '󱐋',
          Operator = '󰪚',
          TypeParameter = '󰬛',
        },
      },
      completion = {
        menu = {
          auto_show = true,
          border = 'rounded',
          min_width = 30,
          max_height = 20,
          draw = {
            -- icon | label + detail | kind (kind moved to the right so labels line up)
            columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 }, { 'kind' } },
            treesitter = { 'lsp' }, -- syntax-highlight LSP labels
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = {
            border = 'rounded',
            max_height = 30,
            max_width = 100,
          },
        },
        list = {
          max_items = 500,
          selection = {
            auto_insert = false,
          },
        },
      },
      signature = {
        enabled = true,
        window = {
          border = 'rounded',
          max_height = 30,
          max_width = 100,
        },
      },
      fuzzy = { implementation = 'prefer_rust_with_warning' },
    },
    opts_extend = { 'sources.default' },
  },

  ------------------------------------------------------------------
  -- Copilot
  ------------------------------------------------------------------
  {
    'zbirenbaum/copilot.lua',
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    enabled = vim.g.neovim_mode ~= 'skitty', -- Disable for skitty mode
    opts = function(_, opts)
      opts = opts or {}

      -- Format username
      local user = (vim.env.USER or 'User'):gsub('^%l', string.upper)
      opts.question_header = string.format(' %s (%s) ', user, opts.model)

      -- Configure mappings
      opts.mappings = {
        close = {
          normal = '',
          insert = '',
        },
        reset = {
          normal = '',
          insert = '',
        },
      }

      return opts
    end,
    keys = {
      {
        '<A-o>',
        function()
          return require('CopilotChat').toggle()
        end,
        desc = 'Toggle Copilot Chat',
        mode = { 'n', 'i', 'v' },
      },
    },
  },

  ------------------------------------------------------------------
  -- LSP, Mason, formatting
  ------------------------------------------------------------------
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'saghen/blink.cmp',
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
    },

    config = function()
      local ensure_installed = {
        'gopls',
        'ts_ls',
        'svelte',
        'html',
        'htmx',
        'tailwindcss',
        'ols',
        'clangd',
        'lua_ls',
        'cssls',
        'eslint',
        'templ',
        'zls',
        'basedpyright',
        'ruff',
      }
      require('mason').setup {
        ensure_installed = ensure_installed,
        ui = { border = 'rounded', backdrop = 100 }, -- 100 = no dimmed backdrop
      }
      require('mason-lspconfig').setup {
        ensure_installed = ensure_installed,
        automatic_installation = true, -- mason-lspconfig v1 only
        automatic_enable = false,      -- servers are enabled explicitly below
      }

      -- Defaults applied to every server
      vim.lsp.config('*', {
        capabilities = require('blink.cmp').get_lsp_capabilities(),
      })

      -- Don't let the templ buffers use these servers' formatting/highlight
      local no_templ_on_attach = function(client, _)
        if vim.bo.filetype == 'templ' then
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
          client.server_capabilities.documentHighlightProvider = false
        end
      end

      vim.lsp.config('gopls', {
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
      })
      vim.lsp.config('ts_ls', {
        root_markers = { '.git' },
      })
      vim.lsp.config('zls', {
        cmd = { 'zls' },
        filetypes = { 'zig', 'zir' },
        root_markers = { 'build.zig', '.git' },
        settings = {
          zls = {
            enable_build_on_save = true,
            enable_argument_placeholders = false,
          },
        },
      })
      vim.lsp.config('html', {
        on_attach = no_templ_on_attach,
        filetypes = { 'html', 'templ', 'javascript', 'typescript' },
        init_options = {
          provideFormatter = false,
        },
      })
      vim.lsp.config('cssls', {
        on_attach = no_templ_on_attach,
        filetypes = { 'css', 'html', 'templ' },
        settings = {
          css = {
            lint = {
              unknownAtRules = 'ignore',
            },
          },
        },
      })
      vim.lsp.config('htmx', {
        on_attach = no_templ_on_attach,
        filetypes = { 'html' },
      })
      vim.lsp.config('tailwindcss', {
        on_attach = no_templ_on_attach,
        filetypes = { 'html', 'templ', 'svelte', 'javascript', 'typescript', 'css' },
        init_options = { userLanguages = { templ = 'html' } },
      })
      -- basedpyright handles hover/types; ruff handles lint/format. Avoid duplicate hovers.
      vim.lsp.config('ruff', {
        on_attach = function(client, _)
          client.server_capabilities.hoverProvider = false
        end,
      })
      vim.lsp.config('lua_ls', {
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
      })

      vim.lsp.enable {
        'templ',
        'gopls',
        'clangd',
        'ts_ls',
        'eslint',
        'svelte',
        'ols',
        'zls',
        'html',
        'cssls',
        'htmx',
        'tailwindcss',
        'lua_ls',
        'basedpyright',
        'ruff',
      }

      vim.diagnostic.config { float = { border = 'single' } }
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
        c = { 'clang-format' },
        h = { 'clang-format' },
        javascript = { 'prettier' },
        typescript = { 'prettier' },
        svelte = { 'prettier' },
        html = { 'prettier' },
        python = { 'ruff_format' },
      },
      formatters = {
        clang_format = {
          args = { '-style=webkit' },
        },
      },
    },
  },

  ------------------------------------------------------------------
  -- Treesitter
  ------------------------------------------------------------------
  { -- Highlight, edit, and navigate code
    -- Uses the `main` branch rewrite (no more `nvim-treesitter.configs`).
    -- Requires the `tree-sitter` CLI to compile parsers.
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      local ts = require 'nvim-treesitter'
      ts.setup {}

      -- Parsers to keep installed (async; no-op for ones already present)
      ts.install {
        'go',
        'gomod',
        'gosum',
        'gowork',
        'gitignore',
        'rust',
        'bash',
        'comment',
        'dockerfile',
        'fish',
        'typescript',
        'c',
        'lua',
        'vim',
        'vimdoc',
        'query',
        'heex',
        'javascript',
        'html',
        'zig',
        'cpp',
        'svelte',
        'sql',
        'gotmpl',
        'python',
        'css',
        'templ',
        'tsx',
      }

      -- Enable highlighting + treesitter indent per buffer, and install a
      -- missing parser on first use (replaces `auto_install`/`highlight`/`indent`).
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('treesitter-start', { clear = true }),
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(args.match)
          if not lang then
            return
          end

          if not vim.tbl_contains(ts.get_installed(), lang) then
            if vim.tbl_contains(ts.get_available(), lang) then
              ts.install(lang) -- async; highlighting starts next time the buffer is opened
            end
            return
          end

          if pcall(vim.treesitter.start, args.buf, lang) then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },

  ------------------------------------------------------------------
  -- Languages
  ------------------------------------------------------------------
  { -- Golang
    'ray-x/go.nvim',
    dependencies = {
      'ray-x/guihua.lua',
    },
    config = function()
      require('go').setup {
        lsp_inlay_hints = {
          enable = false,
        },
        remap_commands = { GoDoc = false },
      }

      -- Run gofmt on save
      local format_sync_grp = vim.api.nvim_create_augroup('GoFormat', {})
      vim.api.nvim_create_autocmd('BufWritePre', {
        pattern = '*.go',
        callback = function()
          require('go.format').goimport()
        end,
        group = format_sync_grp,
      })
    end,
    event = { 'CmdlineEnter' },
    ft = { 'go', 'gomod' },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },
  {
    'fredrikaverpil/godoc.nvim',
    version = '*',
    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter',
        opts = {
          ensure_installed = { 'go' },
        },
      },
    },
    -- build = "go install github.com/lotusirous/gostdsym/stdsym@latest",
    cmd = { 'GoDoc' },
    opts = {
      picker = {
        type = 'telescope',
      },
    },
  },
  {
    'ziglang/zig.vim',
    config = function()
      vim.cmd 'let g:zig_fmt_autosave = 0'
    end,
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },
    opts = {},
  },
  {
    'rest-nvim/rest.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        table.insert(opts.ensure_installed, 'http')
      end,
    },
  },

  ------------------------------------------------------------------
  -- Navigation & search
  ------------------------------------------------------------------
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    version = '*', -- latest release; the old 0.1.x branch breaks with nvim-treesitter's `main` branch
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
    },
    config = function()
      require('telescope').setup {
        defaults = {
          layout_config = {
            -- Preview gets 60% of the picker, the results list 40%
            -- (the default is the reverse on windows under 150 columns)
            horizontal = { preview_width = 0.6 },
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
          fzf = {},
        },
      }

      -- Enable telescope extensions, if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'

      local custom_diagnostics = function()
        builtin.diagnostics { root_dir = true }
      end

      local custom_man = function()
        builtin.man_pages { sections = { 'ALL' } }
      end

      vim.keymap.set('n', '<leader>scc', builtin.colorscheme, { desc = '[S]earch [C]olorscheme' })
      vim.keymap.set('n', '<leader>scs', builtin.commands, { desc = '[S]earch [C]ommand[s]' })
      vim.keymap.set('n', '<leader>sch', builtin.command_history, { desc = '[S]earch [C]ommand [H]istory' })
      vim.keymap.set('n', '<leader>scr', builtin.colorscheme, { desc = '[S]earch [C]olo[R]schemes' })
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>bb', builtin.buffers, { desc = '[B]uffer: find open [B]uffers' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sm', custom_man, { desc = '[S]earch [M]an Pages' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', custom_diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {
      modes = { char = { enabled = false } },
    },
    keys = {
      {
        's',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').jump()
        end,
        desc = 'Flash',
      },
      {
        'S',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').treesitter()
        end,
        desc = 'Flash Treesitter',
      },
    },
  },
  {
    'rmagatti/goto-preview',
    event = 'BufEnter',
    config = function()
      require('goto-preview').setup {
        width = 200,
        height = 45,
      }
    end,
  },
  {
    'stevearc/aerial.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('aerial').setup {
        on_attach = function(bufnr)
          vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr, desc = 'Previous symbol (Aerial)' })
          vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr, desc = 'Next symbol (Aerial)' })
        end,
        layout = {
          max_width = { 40, 0.2 },
          min_width = 20,
          default_direction = 'prefer_left',
        },
        autojump = true,
        close_on_select = true,
      }
      vim.keymap.set('n', '<C-a>', '<cmd>AerialToggle<CR>', { desc = 'Toggle symbol outline (Aerial)' })
    end,
  },
  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    lazy = false, -- needed so `nvim <dir>` opens oil
    keys = {
      { '-', '<cmd>Oil<cr>', desc = 'Open parent directory (Oil)' },
    },
    opts = {
      default_file_explorer = true,
      view_options = {
        show_hidden = true,
      },
      preview_win = {
        -- Load previews as real buffers so snacks.image can render image files
        -- (the default 'fast_scratch' only shows text). Toggle with <C-p>.
        preview_method = 'load',
        -- Skip previews of big files so they can't freeze the editor
        disable_preview = function(filename)
          local stat = (vim.uv or vim.loop).fs_stat(filename)
          if not stat or stat.type ~= 'file' then
            return false
          end
          local image_exts = { png = 1, jpg = 1, jpeg = 1, gif = 1, webp = 1, bmp = 1, tif = 1, tiff = 1, avif = 1, heic = 1, svg = 1, ico = 1 }
          local is_image = image_exts[(filename:match '%.([^./]+)$' or ''):lower()] ~= nil
          local max_bytes = is_image and 16 * 1024 * 1024 or 2 * 1024 * 1024 -- 16 MB images, 2 MB everything else
          return stat.size > max_bytes
        end,
      },
    },
  },
  { -- Inline image rendering (kitty graphics protocol: Ghostty, kitty, WezTerm)
    -- Needs ImageMagick (`magick`); works through tmux with allow-passthrough on.
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      image = { enabled = true },
    },
  },
  { 'alexghergh/nvim-tmux-navigation' },

  ------------------------------------------------------------------
  -- Editing
  ------------------------------------------------------------------
  { 'numToStr/Comment.nvim',          opts = {} },
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },
  {
    'nvim-mini/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      local statusline = require 'mini.statusline'

      -- Transparent bar made of rounded "pills": mode | git + diagnostics | ... | lsp, filetype | position
      local nr = vim.fn.nr2char
      local cap_l, cap_r = nr(0xe0b6), nr(0xe0b4) -- rounded pill ends
      local diag_icons = { Error = nr(0xf015a), Warn = nr(0xf0026), Info = nr(0xf02fc), Hint = nr(0xf0335) }
      local diag_hl = { Error = 'DiagnosticError', Warn = 'DiagnosticWarn', Info = 'DiagnosticInfo', Hint = 'DiagnosticHint' }

      -- Pill ends need fg = the pill's background and a transparent bg. Derived from the
      -- current colorscheme, so (re)build them lazily and whenever the colorscheme changes.
      local hl_ready = false
      local function get_hl(name)
        return vim.api.nvim_get_hl(0, { name = name, link = false })
      end
      local function ensure_hl()
        if hl_ready then
          return
        end
        for _, mode in ipairs { 'Normal', 'Insert', 'Visual', 'Replace', 'Command', 'Other' } do
          vim.api.nvim_set_hl(0, 'MiniStatuslineCap' .. mode, { fg = get_hl('MiniStatuslineMode' .. mode).bg })
        end
        local info_bg = get_hl('MiniStatuslineDevinfo').bg
        vim.api.nvim_set_hl(0, 'MiniStatuslineCapInfo', { fg = info_bg })
        for sev, group in pairs(diag_hl) do
          vim.api.nvim_set_hl(0, 'MiniStatuslineDiag' .. sev, { fg = get_hl(group).fg, bg = info_bg })
        end
        vim.api.nvim_set_hl(0, 'MiniStatuslineDim', { fg = get_hl('Comment').fg })
        hl_ready = true
      end
      vim.api.nvim_create_autocmd('ColorScheme', {
        desc = 'Rebuild statusline pill highlights',
        callback = function()
          hl_ready = false
        end,
      })

      local function pill(text_hl, cap_hl, text)
        return table.concat { '%#', cap_hl, '#', cap_l, '%#', text_hl, '#', text, '%#', cap_hl, '#', cap_r, '%*' }
      end

      local function join(parts)
        return table.concat(vim.tbl_filter(function(p)
          return p ~= ''
        end, parts), ' ')
      end

      -- Per-severity coloured counts, e.g. "E 2  W 1"
      local function diagnostics()
        if statusline.is_truncated(75) then
          return ''
        end
        local counts = vim.diagnostic.count(0)
        local parts = {}
        for _, sev in ipairs { 'Error', 'Warn', 'Info', 'Hint' } do
          local n = counts[vim.diagnostic.severity[sev:upper()]]
          if n and n > 0 then
            parts[#parts + 1] = string.format('%%#MiniStatuslineDiag%s#%s %d', sev, diag_icons[sev], n)
          end
        end
        return table.concat(parts, ' ')
      end

      statusline.setup {
        content = {
          active = function()
            ensure_hl()
            local mode, mode_hl = statusline.section_mode { trunc_width = 120 }
            local suffix = mode_hl:gsub('^MiniStatuslineMode', '')

            local git = statusline.section_git { trunc_width = 40 }
            local diff = statusline.section_diff { trunc_width = 75 }
            -- trunc_width this large always takes the short form: just the filetype icon + name
            local filetype = statusline.section_fileinfo { trunc_width = 9999 }
            -- always the short form: path relative to cwd, with [+]/[RO] flags
            local filename = statusline.section_filename { trunc_width = 9999 }
            local lsp = statusline.section_lsp { trunc_width = 100 }
            local search = statusline.section_searchcount { trunc_width = 75 }

            local info = join { git, diff, diagnostics() }
            local position = '%l:%v  %p%%'

            return join {
              pill(mode_hl, 'MiniStatuslineCap' .. suffix, ' ' .. mode:upper() .. ' '),
              info ~= '' and pill('MiniStatuslineDevinfo', 'MiniStatuslineCapInfo', ' ' .. info .. ' ') or '',
              '%#MiniStatuslineFilename#' .. filename .. '%<',
              '%=',
              lsp ~= '' and ('%#MiniStatuslineDim#' .. lsp) or '',
              search ~= '' and ('%#MiniStatuslineFilename#' .. search) or '',
              filetype ~= '' and pill('MiniStatuslineFileinfo', 'MiniStatuslineCapInfo', ' ' .. filetype .. ' ') or '',
              pill(mode_hl, 'MiniStatuslineCap' .. suffix, ' ' .. position .. ' '),
            }
          end,
          inactive = function()
            return '%#MiniStatuslineInactive# %f%m%='
          end,
        },
      }

      -- mini.statusline sets a statusline on every window it sees, including
      -- floats (blink.cmp menu/docs, hovers), which then show "Normal", "Command", etc.
      -- Clear it again on floats. Registered after setup() so it runs after mini's own autocmds.
      vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter', 'WinLeave', 'BufLeave' }, {
        desc = 'Keep mini.statusline off floating windows',
        callback = function()
          if vim.api.nvim_win_get_config(0).relative ~= '' then
            vim.wo.statusline = ''
          end
        end,
      })

      require('mini.move').setup {
        mappings = {
          left = '<M-H>',
          right = '<M-L>',
          down = '<M-J>',
          up = '<M-K>',
          line_left = '<M-H>',
          line_right = '<M-L>',
          line_down = '<M-J>',
          line_up = '<M-K>',
        },
      }

      require('mini.splitjoin').setup()

      -- Open buffers shown as tabs along the top
      require('mini.tabline').setup {
        format = function(buf_id, label)
          local text = vim.trim(MiniTabline.default_format(buf_id, label)) -- "<icon> <name>"
          local modified = vim.bo[buf_id].modified and ' ●' or '' -- unsaved-changes marker
          return string.format('  %s%s  ', text, modified) -- two spaces of padding on each side
        end,
      }

      -- Buffer management (bufremove keeps window layout when deleting a buffer)
      local bufremove = require 'mini.bufremove'
      bufremove.setup()

      local function delete_other_buffers()
        local current = vim.api.nvim_get_current_buf()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if buf ~= current and vim.bo[buf].buflisted then
            bufremove.delete(buf, false) -- asks before discarding unsaved changes
          end
        end
      end

      vim.keymap.set('n', '<leader>bn', '<cmd>bnext<CR>', { desc = '[B]uffer: [N]ext' })
      vim.keymap.set('n', '<leader>bp', '<cmd>bprevious<CR>', { desc = '[B]uffer: [P]revious' })
      vim.keymap.set('n', 'H', '<cmd>bprevious<CR>', { desc = 'Previous buffer' })
      vim.keymap.set('n', 'L', '<cmd>bnext<CR>', { desc = 'Next buffer' })
      vim.keymap.set('n', '<leader>bl', '<cmd>buffer #<CR>', { desc = '[B]uffer: [L]ast (alternate)' })
      vim.keymap.set('n', '<leader>bd', function()
        bufremove.delete(0, false)
      end, { desc = '[B]uffer: [D]elete' })
      vim.keymap.set('n', '<leader>bD', function()
        bufremove.delete(0, true)
      end, { desc = '[B]uffer: [D]elete (force, discard changes)' })
      vim.keymap.set('n', '<leader>bo', delete_other_buffers, { desc = '[B]uffer: delete [O]thers' })
    end,
  },

  ------------------------------------------------------------------
  -- Git
  ------------------------------------------------------------------
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },
  'tpope/vim-fugitive',
  {
    'kdheepak/lazygit.nvim',
    lazy = true,
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
    -- optional for floating window border decoration
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { '<C-g>', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
    },
  },

  ------------------------------------------------------------------
  -- UI
  ------------------------------------------------------------------
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
    config = function()
      require('noice').setup {
        lsp = {
          override = {
            ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
            ['vim.lsp.util.stylize_markdown'] = true,
            ['cmp.entry.get_documentation'] = true,
          },
          messages = { enabled = false },
          hover = { enabled = true },
          signature = { enabled = true, auto_open = { enabled = false } },
        },
        presets = {
          bottom_search = false,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = true,
        },
      }
    end,
  },
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      notify = false,
      win = { border = 'rounded' },
      spec = {
        { '<leader>b',  group = '[B]uffer' },
        { '<leader>c',  group = '[C]ode' },
        { '<leader>d',  group = '[D]iagnostics / [D]ocument' },
        { '<leader>g',  group = '[G]et / [G]oto' },
        { '<leader>l',  group = '[L]sp' },
        { '<leader>q',  group = '[Q]uickfix' },
        { '<leader>r',  group = '[R]ename' },
        { '<leader>s',  group = '[S]earch' },
        { '<leader>sc', group = '[C]olorschemes / [C]ommands' },
        { '<leader>w',  group = '[W]orkspace' },
      },
    },
  },
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      local Terminal = require('toggleterm.terminal').Terminal
      local fish = Terminal:new { cmd = 'fish', hidden = true, direction = 'float' }

      function _fish_toggle()
        fish:toggle(20)
      end

      vim.keymap.set('n', '<C-t>', '<cmd>lua _fish_toggle()<CR>', { desc = 'Open a terminal under the current window' })
      vim.keymap.set('t', '<C-t>', '<cmd>lua _fish_toggle()<CR>', { desc = 'Close a terminal under the current window' })
    end,
  },
}, {
  ui = { border = 'rounded', backdrop = 100 }, -- 100 = no dimmed backdrop
})

----------------------------------------------------------------------
-- 4. Keymaps
-- (Defined after lazy.setup because several reference plugin modules.)
----------------------------------------------------------------------

-- Clear search highlight
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', function()
  vim.diagnostic.jump { count = -1, float = true }
end, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', function()
  vim.diagnostic.jump { count = 1, float = true }
end, { desc = 'Go to next [D]iagnostic message' })

-- Quickfix
vim.keymap.set('n', '<leader>qo', vim.diagnostic.setloclist, { desc = '[O]pen diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>qc', '<cmd>cclose<CR>', { desc = '[C]lose diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<A-N>', '<cmd>cnext<CR>', { desc = 'Go to next Quickfix' })
vim.keymap.set('n', '<A-P>', '<cmd>cprevious<CR>', { desc = 'Go to previous Quickfix' })

-- Split navigation
local nvim_tmux_nav = require 'nvim-tmux-navigation'
vim.keymap.set('n', '<C-h>', nvim_tmux_nav.NvimTmuxNavigateLeft, { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', nvim_tmux_nav.NvimTmuxNavigateRight, { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', nvim_tmux_nav.NvimTmuxNavigateDown, { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', nvim_tmux_nav.NvimTmuxNavigateUp, { desc = 'Move focus to the upper window' })

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
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = '[C]ode [A]ction' })
vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, { desc = '[R]ename' })
vim.keymap.set('n', '<leader>dd', vim.diagnostic.open_float, { desc = 'Open [D]iagnostic In Hover' })
vim.keymap.set('n', '<leader>i', toggle_inlay, { desc = 'Toggle [I]nlay Hints' })

-- LSP: Hovers
local border = 'single'
local function signature_help()
  vim.lsp.buf.signature_help { border = border, max_width = 140, max_height = 30 }
end
vim.keymap.set('n', 'K', function()
  vim.lsp.buf.hover { border = border, max_width = 140, max_height = 30 }
end, { desc = 'Hover' })
vim.keymap.set('i', '<C-S>', signature_help, { desc = 'Signature Documentation' })
vim.keymap.set('n', '<C-S>', signature_help, { desc = 'Signature Documentation' })

-- LSP: Jumps
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = '[G]oto [D]efinition' })
vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, { desc = '[G]oto [T]ype Definition' })
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = '[G]oto [D]eclaration' })

-- LSP: Previews
local goto_preview = require 'goto-preview'
vim.keymap.set('n', 'gpd', goto_preview.goto_preview_definition, { desc = '[G]oto [P]review [D]efinition' })
vim.keymap.set('n', 'gpr', goto_preview.goto_preview_references, { desc = '[G]oto [P]review [R]eferences' })
vim.keymap.set('n', 'gpt', goto_preview.goto_preview_type_definition, { desc = '[G]oto [P]review [T]ype Definition' })
vim.keymap.set('n', 'gpi', goto_preview.goto_preview_implementation, { desc = '[G]oto [P]review [I]mplementation' })
vim.keymap.set('n', 'gpD', goto_preview.goto_preview_declaration, { desc = '[G]oto [P]review [D]eclaration' })
vim.keymap.set('n', 'gP', goto_preview.close_all_win, { desc = 'Close All [P]reviews' })

-- LSP: Search
local telescope_builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>gd', telescope_builtin.lsp_definitions, { desc = '[G]et [D]efinition' })
vim.keymap.set('n', '<leader>gtd', telescope_builtin.lsp_type_definitions, { desc = '[G]et [T]ype [D]efinition' })
vim.keymap.set('n', 'gr', telescope_builtin.lsp_references, { desc = '[G]et [R]eferences' })
vim.keymap.set('n', '<leader>ds', telescope_builtin.lsp_document_symbols, { desc = '[D]ocument [S]ymbols' })
vim.keymap.set('n', '<leader>ws', telescope_builtin.lsp_dynamic_workspace_symbols, { desc = '[W]orkspace [S]ymbols' })
vim.keymap.set('n', 'gi', telescope_builtin.lsp_implementations, { desc = '[G]et [I]mplementation' })
vim.keymap.set('n', 'gI', telescope_builtin.lsp_incoming_calls, { desc = '[G]et [I]ncoming Calls' })
vim.keymap.set('n', 'gO', telescope_builtin.lsp_outgoing_calls, { desc = '[G]et [O]utgoing Calls' })
