return {
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
    "fredrikaverpil/godoc.nvim",
    version = "*",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter",
        opts = {
          ensure_installed = { "go" },
        },
      },
    },
    -- build = "go install github.com/lotusirous/gostdsym/stdsym@latest",
    cmd = { "GoDoc" },
    opts = {
      picker = {
        type = "telescope"
      },
    },
  },
}
