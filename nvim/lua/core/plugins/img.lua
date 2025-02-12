return {
  'skardyy/neo-img',
  build = "cd ttyimg && go build", -- build ttyimg
  config = function()
    require('neo-img').setup({
      supported_extensions = {
        ['png'] = true,
        ['jpg'] = true,
        ['jpeg'] = true,
        ['webp'] = true,
        ['svg'] = true,
        ['tiff'] = true
      },
      auto_open = true,
      oil_preview = true,
      backend = "kitty",
      size = {
        oil = { x = 400, y = 400 },
        main = { x = 400, y = 400 }
      },
      offset = {
        oil = { x = 5, y = 3 },
        main = { x = 10, y = 3 }
      },
      resizeMode = "Fit"
    })
  end
}
