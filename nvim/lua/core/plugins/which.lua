return {
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opt = {
      notify = false,
    },
    keys = {
      { "<leader>c", group = "[C]ode" },
      { "<leader>h", group = "[H]arpoon" },
      { "<leader>l", group = "[L]sp" },
      { "<leader>q", group = "[Q]uickfix" },
      { "<leader>r", group = "[R]ename" },
      { "<leader>s", group = "[S]earch" },
      { "<leader>w", group = "[W]orkspace" },
    },
  },
}
