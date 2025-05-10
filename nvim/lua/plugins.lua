return {
	{
		"catppuccin/nvim",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		name = "catppuccin",
		opts = {
			flavour = "auto", -- latte, frappe, macchiato, mocha
			background = { -- :h background
				light = "latte",
				dark = "macchiato",
			},
			integrations = {
				cmp = true,
				mini = {
					enabled = true,
					indentscope_color = "",
				},
				treesitter = true,
				mason = true,
			},
		},
		config = function()
			vim.cmd([[colorscheme catppuccin-macchiato]])
		end,
	},
	{
		"f-person/auto-dark-mode.nvim",
		opts = {}, -- It uses vims background by default, which catppuccin seems to support
	},
	{ "echasnovski/mini.extra", version = false, opts = {} },
	{
		"echasnovski/mini.notify",
		version = false,
		config = function()
			require("mini.notify").setup({
				window = { config = { border = "none" } },
			})
			vim.notify = MiniNotify.make_notify()
		end,
	},
	{
		"echasnovski/mini.clue",
		version = false,
		config = function()
			local miniclue = require("mini.clue")
			miniclue.setup({
				clues = {
					_G.Config.leader_group_clues,
					miniclue.gen_clues.builtin_completion(),
					miniclue.gen_clues.g(),
					miniclue.gen_clues.marks(),
					miniclue.gen_clues.registers(),
					miniclue.gen_clues.windows({ submode_resize = true }),
					miniclue.gen_clues.z(),
				},
				triggers = {
					{ mode = "n", keys = "<Leader>" }, -- Leader triggers
					{ mode = "x", keys = "<Leader>" },
					{ mode = "n", keys = [[\]] }, -- mini.basics
					{ mode = "n", keys = "[" }, -- mini.bracketed
					{ mode = "n", keys = "]" },
					{ mode = "x", keys = "[" },
					{ mode = "x", keys = "]" },
					{ mode = "i", keys = "<C-x>" }, -- Built-in completion
					{ mode = "n", keys = "g" }, -- `g` key
					{ mode = "x", keys = "g" },
					{ mode = "n", keys = "'" }, -- Marks
					{ mode = "n", keys = "`" },
					{ mode = "x", keys = "'" },
					{ mode = "x", keys = "`" },
					{ mode = "n", keys = '"' }, -- Registers
					{ mode = "x", keys = '"' },
					{ mode = "i", keys = "<C-r>" },
					{ mode = "c", keys = "<C-r>" },
					{ mode = "n", keys = "<C-w>" }, -- Window commands
					{ mode = "n", keys = "z" }, -- `z` key (folding!)
					{ mode = "x", keys = "z" },
				},
				window = {
					delay = 300,
					config = { border = "single", anchor = "SW", row = "auto", col = "auto", width = "auto" },
				},
			})
		end,
	},
	{ "echasnovski/mini.statusline", version = false, opts = {} },
	-- { "nvim-tree/nvim-web-devicons" },
	{
		"echasnovski/mini.icons",
		opts = {},
		lazy = true,
		specs = {
			{ "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
		},
		init = function()
			package.preload["nvim-web-devicons"] = function()
				require("mini.icons").mock_nvim_web_devicons()
				return package.loaded["nvim-web-devicons"]
			end
		end,
	},
	-- Those might be part of different files and called on later events?
	{
		"echasnovski/mini.ai",
		version = false,
		confg = function()
			local ai = require("mini.ai")
			local extra = require("mini.extra")
			ai.setup({
				n_lines = 500,
				custom_textobjects = {
					B = extra.gen_ai_spec.buffer(),
					F = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
				},
			})
		end,
	},
	{ "echasnovski/mini.cursorword", version = false, opts = {} },
	{ "echasnovski/mini.surround", version = false, opts = {} },
	{
		"echasnovski/mini.hipatterns",
		version = false,
		config = function()
			local hipatterns = require("mini.hipatterns")
			hipatterns.setup({

				highlighters = {
					-- Highlight hex color strings (`#rrggbb`) using that color
					hex_color = hipatterns.gen_highlighter.hex_color(),
					-- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
					fixme = { pattern = "() FIXME():", group = "MiniHipatternsFixme" },
					hack = { pattern = "() HACK():", group = "MiniHipatternsHack" },
					todo = { pattern = "() TODO():", group = "MiniHipatternsTodo" },
					note = { pattern = "() NOTE():", group = "MiniHipatternsNote" },
					fixme_colon = { pattern = " FIXME():()", group = "MiniHipatternsFixmeColon" },
					hack_colon = { pattern = " HACK():()", group = "MiniHipatternsHackColon" },
					todo_colon = { pattern = " TODO():()", group = "MiniHipatternsTodoColon" },
					note_colon = { pattern = " NOTE():()", group = "MiniHipatternsNoteColon" },
					fixme_body = { pattern = " FIXME:().*()", group = "MiniHipatternsFixmeBody" },
					hack_body = { pattern = " HACK:().*()", group = "MiniHipatternsHackBody" },
					todo_body = { pattern = " TODO:().*()", group = "MiniHipatternsTodoBody" },
					note_body = { pattern = " NOTE:().*()", group = "MiniHipatternsNoteBody" },
				},
			})
		end,
	},
}
