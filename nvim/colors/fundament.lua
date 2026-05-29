-- fundament.lua
-- Usage: :colorscheme fundament
-- Toggle variant: :set background=light / :set background=dark

vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") then
	vim.cmd("syntax reset")
end
vim.g.colors_name = "fundament"

local hi = vim.api.nvim_set_hl

-- ============================================================
-- PALETTES
-- ============================================================
---@enum Color
local Color = {
	NEUTRAL_50 = "#FAFAFA",
	NEUTRAL_100 = "#F5F5F5",
	NEUTRAL_200 = "#E5E5E5",
	NEUTRAL_300 = "#D4D4D4",
	NEUTRAL_400 = "#A1A1A1",
	NEUTRAL_500 = "#737373",
	NEUTRAL_600 = "#525252",
	NEUTRAL_700 = "#404040",
	NEUTRAL_800 = "#262626",
	NEUTRAL_900 = "#171717",
	NEUTRAL_950 = "#0A0A0A",
	MAUVE_50 = "#FAFAFA",
	MAUVE_100 = "#F3F1F3",
	MAUVE_200 = "#E7E4E7",
	MAUVE_300 = "#D7D0D7",
	MAUVE_400 = "#A89EA9",
	MAUVE_500 = "#79697B",
	MAUVE_600 = "#594C5B",
	MAUVE_700 = "#463947",
	MAUVE_800 = "#2A212C",
	MAUVE_900 = "#1D161E",
	MAUVE_950 = "#0C090C",
	BLACK = "#000000",
	WHITE = "#FFFFFF",
}
local dark = {
	-- Backgrounds (use these to create depth and signal)
	bg = Color.BLACK, -- OLED black
	bg_subtle = Color.NEUTRAL_900, -- cursorline, subtle grouping
	bg_float = Color.MAUVE_900, -- popups, floats
	bg_visual = "#1a2a1a", -- visual selection (green tint = selected, not error)
	bg_search = "#2a2000", -- search match
	bg_error = "#1a0000", -- error line bg
	bg_warn = "#1a1200", -- warning line bg
	bg_add = "#001a00", -- diff add
	bg_del = "#1a0000", -- diff delete

	-- Foregrounds
	fg = Color.NEUTRAL_300, -- normal text, comments (equal weight intentional)
	fg_dim = Color.NEUTRAL_600, -- punctuation, brackets — receding structure
	fg_strong = Color.WHITE, -- definitions, things that must pop

	-- Accents (use sparingly — each one costs attention budget)
	accent = "#7ab0ff", -- primary accent: references, links
	literal = Color.NEUTRAL_300, -- string/number literals — values, not structure

	-- Diagnostics (reserved — don't reuse these hues elsewhere)
	-- TODO: Set these
	error = Color.WHITE,
	warn = Color.WHITE,
	hint = Color.WHITE,
	info = Color.WHITE,

	-- Diff
	add = "#44aa44",
	del = "#aa3333",
	change = "#aa8800",

	-- UI chrome
	border = Color.MAUVE_800,
	status_bg = Color.MAUVE_700,
	status_fg = Color.MAUVE_300,
}

local light = {
	-- Backgrounds
	-- Strategy: use bg colour to signal, not fg contrast against white
	bg = "#f5f0e8", -- warm off-white — easier than pure white
	bg_subtle = "#e8e0d0", -- cursorline
	bg_float = "#ede8e0", -- popups
	bg_visual = "#c8ddc8", -- visual selection
	bg_search = "#ddd0a0", -- search
	bg_error = "#f0d0d0", -- error line
	bg_warn = "#f0e0c0", -- warning line
	bg_add = "#c8e0c8", -- diff add
	bg_del = "#e8c8c8", -- diff delete

	-- Foregrounds
	fg = "#2a2a2a", -- normal text
	fg_dim = "#aaaaaa", -- punctuation — receding
	fg_strong = "#000000", -- definitions

	-- Accents
	accent = "#2255cc", -- darker blue for light bg legibility
	literal = "#226622", -- darker green

	-- Diagnostics
	error = "#cc2222",
	warn = "#aa6600",
	hint = "#999999",
	info = "#2255cc",

	-- Diff
	add = "#226622",
	del = "#882222",
	change = "#886600",

	-- UI chrome
	border = "#cccccc",
	status_bg = "#e0d8c8",
	status_fg = "#666666",
}

local c = vim.o.background == "light" and light or dark

-- ============================================================
-- HIGHLIGHTS
-- ============================================================
-- Start minimal. Use :Inspect to discover what you actually need.
-- Add groups here as you encounter them in real usage.
-- Docs: https://neovim.io/doc/user/api/#nvim_set_hl()

-- Base
hi(0, "Normal", { fg = c.fg, bg = c.bg })
hi(0, "NormalFloat", { fg = c.fg, bg = c.bg_float })
hi(0, "NormalNC", { fg = c.fg, bg = c.bg }) -- non-current windows

-- Cursor & selection
hi(0, "CursorLine", { bg = c.bg_subtle })
hi(0, "CursorLineNr", { fg = c.fg_dim, bg = c.bg_subtle, bold = true })
hi(0, "LineNr", { fg = c.fg_dim })
hi(0, "Visual", { bg = c.bg_visual })
hi(0, "Search", { bg = c.bg_search })
hi(0, "IncSearch", { bg = c.bg_search, bold = true })
hi(0, "CursorWord", { bg = c.bg_subtle }) -- if using nvim-cursorword

-- Syntax
-- Comments equal weight to code — intentional
hi(0, "Comment", { fg = c.fg })
-- Punctuation recedes
hi(0, "Delimiter", { fg = c.fg_dim })
hi(0, "Operator", { fg = c.fg_dim })
-- Literals get their own colour — values are meaningful
hi(0, "String", { fg = c.literal })
hi(0, "Number", { fg = c.literal })
hi(0, "Boolean", { fg = c.literal })
-- Everything else: neutral until :Inspect tells you otherwise
hi(0, "Keyword", { fg = c.fg })
hi(0, "Function", { fg = c.fg })
hi(0, "Type", { fg = c.fg })
hi(0, "Identifier", { fg = c.fg })
hi(0, "Constant", { fg = c.fg_strong })
hi(0, "PreProc", { fg = c.fg })
hi(0, "Special", { fg = c.fg })

-- Definitions pop (LSP-driven alternatives exist — see below)
hi(0, "Title", { fg = c.fg_strong, bold = true })

-- UI structure
hi(0, "WinSeparator", { fg = c.border })
hi(0, "FloatBorder", { fg = c.border, bg = c.bg_float })
hi(0, "Pmenu", { fg = c.fg, bg = c.bg_float })
hi(0, "PmenuSel", { fg = c.fg_strong, bg = c.bg_visual, bold = true })
hi(0, "PmenuSbar", { bg = c.bg_subtle })
hi(0, "PmenuThumb", { bg = c.fg_dim })

-- Statusline
hi(0, "StatusLine", { fg = c.status_fg, bg = c.status_bg })
hi(0, "StatusLineNC", { fg = c.status_fg, bg = Color.MAUVE_900 })

-- Diagnostics: background-driven — consistent with light theme strategy
hi(0, "DiagnosticError", { fg = c.error })
hi(0, "DiagnosticWarn", { fg = c.warn })
hi(0, "DiagnosticHint", { fg = c.hint })
hi(0, "DiagnosticInfo", { fg = c.info })
hi(0, "DiagnosticUnderlineError", { sp = c.error, undercurl = true })
hi(0, "DiagnosticUnderlineWarn", { sp = c.warn, undercurl = true })
hi(0, "DiagnosticVirtualTextError", { fg = c.error, bg = c.bg_error })
hi(0, "DiagnosticVirtualTextWarn", { fg = c.warn, bg = c.bg_warn })

-- Diff
hi(0, "DiffAdd", { fg = c.add, bg = c.bg_add })
hi(0, "DiffDelete", { fg = c.del, bg = c.bg_del })
hi(0, "DiffChange", { bg = c.bg_warn })
hi(0, "DiffText", { fg = c.change, bold = true })

-- Treesitter (add as :Inspect surfaces them)
-- These override legacy groups in modern configs — don't neglect them
hi(0, "@comment", { link = "Comment" })
hi(0, "@punctuation", { fg = c.fg_dim })
hi(0, "@punctuation.bracket", { fg = c.fg_dim })
hi(0, "@punctuation.delimiter", { fg = c.fg_dim })
hi(0, "@string", { link = "String" })
hi(0, "@number", { link = "Number" })
hi(0, "@boolean", { link = "Boolean" })
-- Everything else links to Normal until you decide otherwise
hi(0, "@variable", { fg = c.fg_strong })
hi(0, "@function", { fg = c.fg })
hi(0, "@keyword", { fg = c.fg })
hi(0, "@type", { fg = c.fg, italic = true })

-- LSP semantic tokens (commonly missed — causes inconsistency)
-- Uncomment and adjust as :Inspect surfaces them
-- hi(0, "@lsp.type.function",  { fg = c.fg })
-- hi(0, "@lsp.type.variable",  { fg = c.fg })
-- hi(0, "@lsp.type.keyword",   { fg = c.fg })

-- LSP document highlight (dynamic — highlights all refs to symbol under cursor)
-- This can replace static definition highlighting
hi(0, "LspReferenceText", { bg = c.bg_subtle })
hi(0, "LspReferenceRead", { bg = c.bg_subtle })
hi(0, "LspReferenceWrite", { bg = c.bg_subtle, bold = true })

-- Extmarks
hi(0, "DiagnosticUnderlineError", { sp = c.error, underline = true })
hi(0, "DiagnosticUnderlineWarn", { sp = c.warn, underline = true })
-- ============================================================
-- BACKGROUND TOGGLE AUTOCMD
-- Re-applies theme when :set background=light/dark is called
-- ============================================================
vim.api.nvim_create_autocmd("OptionSet", {
	pattern = "background",
	callback = function()
		vim.cmd("colorscheme fundament")
	end,
})
