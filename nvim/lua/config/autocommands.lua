-- [[ Basic Autocommands ]]
--  See :help lua-guide-autocommands
local augroup = vim.api.nvim_create_augroup
local baumertnGroup = augroup("baumertn", {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup("HighlightYank", { clear = true })

-- Remove trailing whitespace on save.
autocmd({ "BufWritePre" }, {
	group = baumertnGroup,
	pattern = "*",
	command = [[%s/\s\+$//e]],
})

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = yank_group,
	callback = function()
		vim.highlight.on_yank()
	end,
})
