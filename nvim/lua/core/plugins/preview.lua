return {
  {
    "rmagatti/goto-preview",
    event = "BufEnter",
    config = function()
      require('goto-preview').setup {
        width = 200,
        height = 80,
      }
    end,
  },
}
