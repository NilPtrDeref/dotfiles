local M = {}

M.rust_tools = {
  plugin = true,
  n = {
	["<leader>rd"] = {
	  "<cmd> RustHoverActions <CR><cmd> RustHoverActions <CR>",
	  "Show hover actions"
	},
  }
}

M.gopher = {
  plugin = true,
  n = {
    ["<leader>gsj"] = {
      "<cmd> GoTagAdd json <CR>",
      "Add json struct tags"
    },
    ["<leader>gsy"] = {
      "<cmd> GoTagAdd yaml <CR>",
      "Add yaml struct tags"
    },
  }
}

return M
