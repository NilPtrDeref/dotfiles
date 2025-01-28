return {
  {
    "rmagatti/goto-preview",
    event = "BufEnter",
    config = function()
      require('goto-preview').setup {
        width = 140,
        height = 30,
      }
    end,
  },
}
