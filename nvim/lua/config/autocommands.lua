-- [[ Basic Autocommands ]]
--  See :help lua-guide-autocommands
local baumertnGroup = vim.api.nvim_create_augroup("baumertn", {})
local yank_group = vim.api.nvim_create_augroup("HighlightYank", { clear = true })

-- Remove trailing whitespace on save.
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = baumertnGroup,
	pattern = "*",
	command = [[%s/\s\+$//e]],
})

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = yank_group,
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	desc = "Treesitter",
	pattern = _G.Config.treesitter_parsers,
	callback = function()
		-- syntax highlighting, provided by Neovim
		vim.treesitter.start()
		-- folds, provided by Neovim
		vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.wo.foldmethod = "expr"
		-- indentation, provided by nvim-treesitter
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})
