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

	-- Red, Amber, Blue are meaningful colors.
	-- Do not use them for normal theming
	RED_BRIGHT = "#fcd9d9",
	RED_BASE = "#ef4444",
	RED_DARK = "#380505",

	AMBER_BRIGHT = "#FCE0B1",
	AMBER_BASE = "#f59e0b",
	AMBER_DARK = "#281901",

	BLUE_BRIGHT = "#D8F1FD",
	BLUE_BASE = "#38bdf8",
	BLUE_DARK = "#021B27",

	ACCENT_100 = "#F5ECFE",
	ACCENT_200 = "#CF9EFA",
	ACCENT_300 = "#B264F7",
	ACCENT_500 = "#9333ea",
	ACCENT_600 = "#6C0AC2",
	ACCENT_700 = "#4C0788",
	ACCENT_800 = "#160227",

	BLACK = "#000000",
	WHITE = "#FFFFFF",
}
local dark = {
	bg = Color.BLACK, -- OLED black
	bg_subtle = Color.NEUTRAL_900, -- cursorline, subtle grouping
	-- Visual mode selection color.
	-- No `fg` to preserve the colour of the selected text element.
	visual = { bg = Color.MAUVE_800 },
	-- Search machtes
	search = { fg = Color.BLACK, bg = Color.NEUTRAL_200 },
	cursearch = { fg = Color.NEUTRAL_300, bg = Color.ACCENT_700, bold = true },

	fg = Color.NEUTRAL_300, -- normal text, comments (equal weight intentional)
	fg_dim = Color.NEUTRAL_600, -- punctuation, brackets — receding structure
	fg_strong = Color.WHITE, -- definitions, things that must pop

	-- Accents (use sparingly — each one costs attention budget)

	accent = Color.ACCENT_500,
	literal = Color.WHITE, -- string/number literals — values, not structure

	-- Diagnostics (reserved — don't reuse these hues elsewhere)
	error_fg = Color.RED_BASE,
	error_bg = Color.RED_DARK,
	warn_fg = Color.AMBER_BASE,
	warn_bg = Color.AMBER_DARK,
	hint_fg = Color.BLUE_BASE,
	hint_bg = Color.BLUE_DARK,
	info_fg = Color.BLUE_BASE,
	info_bg = Color.BLUE_DARK,

	-- Diff
	add = { fg = Color.BLUE_BASE, bg = Color.BLUE_DARK },
	del = { fg = Color.RED_BASE, bg = Color.RED_DARK },
	change = { fg = Color.AMBER_BASE, bg = Color.AMBER_DARK },

	-- UI chrome
	border = Color.NEUTRAL_700,
	status = { fg = Color.NEUTRAL_300, bg = "None" },
}

local light = {
	-- TODO: Implement light theme
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
hi(0, "NormalFloat", { fg = c.fg, bg = c.bg })
hi(0, "NormalNC", { fg = c.fg, bg = c.bg }) -- non-current windows

-- Cursor & selection
hi(0, "CursorLine", { bg = c.bg_subtle })
hi(0, "CursorLineNr", { fg = c.fg_dim, bg = c.bg_subtle, bold = true })
hi(0, "LineNr", { fg = c.fg_dim })
hi(0, "Visual", c.visual)
hi(0, "Search", c.search)
hi(0, "IncSearch", { bg = c.serach_bg, bold = true })
hi(0, "CurSearch", c.cursearch)
hi(0, "CursorWord", { bg = c.bg_subtle }) -- if using nvim-cursorword

-- Syntax
-- Comments equal weight to code — intentional
hi(0, "Comment", { fg = c.fg })
-- Punctuation recedes
hi(0, "Delimiter", { fg = c.fg })
hi(0, "Operator", { fg = c.fg })
-- Literals get their own colour — values are meaningful
hi(0, "String", { fg = c.literal })
hi(0, "Number", { fg = c.literal })
hi(0, "Boolean", { fg = c.literal })
-- Everything else: neutral until :Inspect tells you otherwise
hi(0, "Keyword", { fg = c.fg })
hi(0, "Function", { fg = c.fg })
hi(0, "Type", { fg = c.fg })
hi(0, "Identifier", { fg = c.fg })
hi(0, "Constant", { fg = c.fg, bold = true })
hi(0, "PreProc", { fg = c.fg })
hi(0, "Special", { fg = c.fg })

-- Definitions pop (LSP-driven alternatives exist — see below)
hi(0, "Title", { fg = c.fg_strong, bold = true })

-- UI structure
hi(0, "WinSeparator", { fg = c.border })
hi(0, "FloatBorder", { fg = c.border, bg = c.bg })
hi(0, "Pmenu", { fg = c.fg, bg = c.bg })
hi(0, "PmenuSel", { fg = c.fg_strong, bg = c.bg_visual, bold = true })
hi(0, "PmenuSbar", { bg = c.bg_subtle })
hi(0, "PmenuThumb", { bg = c.fg_dim })

-- Statusline
hi(0, "StatusLine", c.status)
hi(0, "StatusLineNC", c.status)

-- MiniStatuslineModeVisual xxx links to DiffAdd
-- MiniStatuslineModeReplace xxx links to DiffDelete
-- MiniStatuslineModeOther xxx links to IncSearch
-- MiniStatuslineModeNormal xxx links to Cursor
-- MiniStatuslineModeInsert xxx links to DiffChange
-- MiniStatuslineModeCommand xxx links to DiffText

-- Diagnostics: background-driven — consistent with light theme strategy
hi(0, "DiagnosticError", { fg = c.error_fg })
hi(0, "DiagnosticWarn", { fg = c.warn_fg })
hi(0, "DiagnosticHint", { fg = c.hint_fg })
hi(0, "DiagnosticInfo", { fg = c.info_fg })
hi(0, "DiagnosticUnderlineError", { sp = c.error_fg, undercurl = true })
hi(0, "DiagnosticUnderlineWarn", { sp = c.warn_fg, undercurl = true })
hi(0, "DiagnosticVirtualTextError", { fg = c.error_fg, bg = c.error_bg })
hi(0, "DiagnosticVirtualTextWarn", { fg = c.warn_fg, bg = c.warn_bg })

-- Markup
hi(0, "@markup", { fg = c.text }) -- For strings considerated text in a markup language.
hi(0, "@markup.strong", { fg = c.red, bold = true }) -- bold
hi(0, "@markup.italic", { fg = c.red, italic = true }) -- italic
hi(0, "@markup.strikethrough", { fg = c.text, strikethrough = true }) -- strikethrough text
hi(0, "@markup.underline", { link = "Underlined" }) -- underlined text
hi(0, "@markup.heading", { fg = c.blue }) -- titles like: # Example
hi(0, "@markup.heading.markdown", { bold = true }) -- bold headings in markdown, but not in HTML or other markup
hi(0, "@markup.math", { fg = c.blue }) -- math environments (e.g. `$ ... $` in LaTeX)
hi(0, "@markup.quote", { fg = c.pink }) -- block quotes
hi(0, "@markup.environment", { fg = c.pink }) -- text environments of markup languages
hi(0, "@markup.environment.name", { fg = c.blue }) -- text indicating the type of an environment
hi(0, "@markup.link", { fg = c.lavender }) -- text references, footnotes, citations, etc.
hi(0, "@markup.link.label", { fg = c.lavender }) -- link, reference descriptions
hi(0, "@markup.link.url", { fg = c.blue, italic = true, underline = true }) -- urls, links and emails
hi(0, "@markup.raw", { fg = c.green }) -- used for inline code in markdown and for doc in python (""")
hi(0, "@markup.list", { fg = c.teal })
hi(0, "@markup.list.checked", { fg = c.green }) -- todo notes
hi(0, "@markup.list.unchecked", { fg = c.overlay1 }) -- todo notes

-- Diff
hi(0, "DiffAdd", c.add)
hi(0, "DiffDelete", c.del)
hi(0, "DiffChange", c.change)
hi(0, "DiffText", { fg = c.change.fg, bold = true })

-- Treesitter (add as :Inspect surfaces them)
-- These override legacy groups in modern configs — don't neglect them
hi(0, "@comment", { link = "Comment" })
hi(0, "@comment.documentation", { link = "Comment" })
hi(0, "@punctuation", { fg = c.fg })
hi(0, "@punctuation.bracket", { fg = c.fg })
hi(0, "@punctuation.delimiter", { fg = c.fg })
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
hi(0, "DiagnosticUnderlineError", { sp = c.error_fg, underline = true })
hi(0, "DiagnosticUnderlineWarn", { sp = c.warn_fg, underline = true })
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
