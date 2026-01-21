-- Global Config
_G.Config = {
	inlay_hints_visible = true,
	treesitter_parsers = {
		-- Vim
		"lua",
		"vim",
		"vimdoc",
		"luadoc",
		-- Shell
		"bash",
		"fish",
		-- Web
		"css",
		"html",
		"javascript",
		"tsx",
		-- Python
		"python",
		"htmldjango",
		-- Git
		"git_config",
		"gitcommit",
		"git_rebase",
		"gitignore",
		"gitattributes",
		-- Elixir
		"elixir",
		"eex",
		"heex",
		-- Ohter
		"c",
		"go",
		-- "c_sharp",
		"regex",
		"markdown",
		"markdown_inline",
		"query",
		"json",
		"toml",
		"sql",
	},
}
_G.Util = {}
_G.Util.keymap = function(mode, keys, cmd, opts)
	opts = opts or {}
	if opts.silent == nil then
		opts.silent = true
	end
	vim.keymap.set(mode, keys, cmd, opts)
end
_G.Util.nmap_leader = function(suffix, rhs, desc, opts)
	opts = opts or {}
	opts.desc = desc
	_G.Util.keymap("n", "<leader>" .. suffix, rhs, opts)
end
_G.Util.xmap_leader = function(suffix, rhs, desc, opts)
	opts = opts or {}
	opts.desc = desc
	_G.Util.keymap("x", "<leader>" .. suffix, rhs, opts)
end

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
require("config.autocommands")
require("config.mappings")
require("config.settings")
if vim.g.vscode then
	require("config.vscode")
end

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- import your plugins
		{ import = "plugins" },
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	-- install = { colorscheme = { "habamax" } },
	-- automatically check for plugin updates
	checker = { enabled = true, notify = true },
})
-- -- The line beneath this is called `modeline`. See `:help modeline`
-- -- vim: ts=2 sts=2 sw=2 et
