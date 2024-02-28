require("copilot").setup({
	enabled = true,
	auto_refresh = true,
	suggestion = {
		enabled = true,
		auto_trigger = true,
		debounce = 75,
		keymap = {
			accept = "<C-Y>",
			dismiss = "<C-u>",
		}
	}
})
