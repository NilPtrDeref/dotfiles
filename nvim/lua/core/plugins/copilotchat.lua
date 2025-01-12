return {
  "CopilotC-Nvim/CopilotChat.nvim",
  enabled = vim.g.neovim_mode ~= "skitty", -- Disable for skitty mode
  opts = function(_, opts)
    -- Initialize options
    opts = opts or {}

    -- Format username
    local user = (vim.env.USER or "User"):gsub("^%l", string.upper)
    opts.question_header = string.format(" %s (%s) ", user, opts.model)

    -- Configure mappings
    opts.mappings = {
      close = {
        normal = "",
        insert = "",
      },
      reset = {
        normal = "",
        insert = "",
      },
    }

    return opts
  end,
  keys = {
    {
      "<A-o>",
      function()
        return require("CopilotChat").toggle()
      end,
      desc = "Toggle Copilot Chat",
      mode = { "n", "i", "v" },
    },
  },
}
