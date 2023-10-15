return {
	-- Colorscheme
	{"catppuccin/nvim", name = "catppuccin", priority = 1000},

	-- LSP
	{"VonHeikemen/lsp-zero.nvim"},
	{"williamboman/mason.nvim"},
	{"williamboman/mason-lspconfig.nvim"},
	{"neovim/nvim-lspconfig"},
	{'hrsh7th/nvim-cmp'},
	{'hrsh7th/cmp-nvim-lsp'},
	{'hrsh7th/cmp-buffer'},
	{'hrsh7th/cmp-path'},
	{'L3MON4D3/LuaSnip'},
	{'rafamadriz/friendly-snippets'},

	-- Telescope
	{'nvim-telescope/telescope.nvim', tag = '0.1.4', dependencies = {'nvim-lua/plenary.nvim'}},

	-- Treesitter
	{"nvim-treesitter/nvim-treesitter"},
	{"nvim-treesitter/playground"},

	-- Copilot
	{"github/copilot.vim"},

	-- Harpoon
	{"ThePrimeagen/harpoon"},

	-- Undotree
	{"mbbill/undotree"},

	-- Fugitive
	{"tpope/vim-fugitive"},

    -- Golang
    { "ray-x/go.nvim",
        dependencies = {
            "ray-x/guihua.lua",
        },
        config = function()
            require("go").setup()
        end,
        event = {"CmdlineEnter"},
        ft = {"go", 'gomod'},
        build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
    },

    -- Autopairs (brackets, quotes, etc)
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        opts = {} -- this is equalent to setup({}) function
    },

    -- Which-Key
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {
        },
    },
}
