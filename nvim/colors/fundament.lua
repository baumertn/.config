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
	--
	-- _BRIGHT = wash background (light bg) — _DARK = wash background (dark bg)
	-- _BASE   = readable ink on a dark bg
	-- _DEEP   = readable ink on a light bg (_BASE is far too pale there)
	RED_BRIGHT = "#fcd9d9",
	RED_BASE = "#ef4444",
	RED_DEEP = "#B42318",
	RED_DARK = "#380505",

	AMBER_BRIGHT = "#FCE0B1",
	AMBER_BASE = "#f59e0b",
	AMBER_DEEP = "#92400E",
	AMBER_DARK = "#281901",

	BLUE_BRIGHT = "#D8F1FD",
	BLUE_BASE = "#38bdf8",
	BLUE_DEEP = "#075985",
	BLUE_DARK = "#021B27",

	ACCENT_100 = "#F5ECFE",
	ACCENT_200 = "#CF9EFA",
	ACCENT_300 = "#B264F7",
	ACCENT_500 = "#9333ea",
	ACCENT_600 = "#6C0AC2",
	ACCENT_700 = "#4C0788",
	ACCENT_800 = "#160227",

	TEAL_300 = "#6BBFB0", -- literals on dark  — LCh: L*72 C*29 h181
	TEAL_700 = "#00695C", -- literals on light — LCh: L*39 C*29 h180
	-- Both carry the same chroma and hue, so literals separate from the neutral
	-- text by the same perceptual distance in either variant (dE ~32).
	-- If TEAL_700 reads too close to normal text in practice, escalate to
	-- "#046F5F" (C*31, dE 34, 5.84:1) or "#0D7A66" (C*33, dE 38, 5.04:1).

	BLACK = "#000000",
	WHITE = "#FFFFFF",
}
local dark = {
	bg = Color.BLACK, -- OLED black
	bg_subtle = Color.NEUTRAL_900, -- cursorline, subtle grouping
	-- Visual mode selection color.
	-- No `fg` to preserve the colour of the selected text element.
	visual = { bg = Color.MAUVE_800 },
	-- Search matches
	search = { fg = Color.BLACK, bg = Color.NEUTRAL_200 },
	cursearch = { fg = Color.BLACK, bg = Color.ACCENT_300, bold = true },

	fg = Color.NEUTRAL_300, -- normal text, comments (equal weight intentional)
	fg_dim = Color.NEUTRAL_600, -- punctuation, brackets — receding structure
	fg_strong = Color.WHITE, -- definitions, things that must pop

	-- Accents (use sparingly — each one costs attention budget)

	accent = Color.ACCENT_300,
	literal = Color.TEAL_300, -- string/number literals — values, not structure

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
	-- DiffText sits inside a DiffChange line — needs a brighter fg to separate
	change_strong = { fg = Color.AMBER_BRIGHT, bg = Color.AMBER_DARK, bold = true },

	-- UI chrome
	border = Color.NEUTRAL_700,
	status = { fg = Color.NEUTRAL_300, bg = "NONE" },
}

-- Light is an override layer on top of dark, so a missing key degrades to the
-- dark value instead of nil (nvim_set_hl throws on a nil table).
--
-- Mirrors dark's *contrast ratios*, not its literal values: every role sits at
-- roughly the same distance from the background as its dark counterpart, so the
-- same things recede and the same things pop.
local light = {
	bg = Color.NEUTRAL_50, -- paper, not pure white — pure white glares
	bg_subtle = Color.NEUTRAL_200, -- cursorline, subtle grouping
	-- Visual mode selection color.
	-- No `fg` to preserve the colour of the selected text element.
	-- Mauve, and a step past bg_subtle so selection ≠ cursorline.
	visual = { bg = Color.MAUVE_300 },
	-- Search matches — inverted block, mirroring dark's bright-on-black
	search = { fg = Color.NEUTRAL_50, bg = Color.NEUTRAL_600 },
	cursearch = { fg = Color.WHITE, bg = Color.ACCENT_600, bold = true },

	fg = Color.NEUTRAL_700, -- normal text, comments (equal weight intentional)
	fg_dim = Color.NEUTRAL_400, -- punctuation, brackets — receding structure
	fg_strong = Color.BLACK, -- definitions, things that must pop

	-- Accents (use sparingly — each one costs attention budget)

	accent = Color.ACCENT_500,
	literal = Color.TEAL_700, -- string/number literals — values, not structure

	-- Diagnostics (reserved — don't reuse these hues elsewhere)
	error_fg = Color.RED_DEEP,
	error_bg = Color.RED_BRIGHT,
	warn_fg = Color.AMBER_DEEP,
	warn_bg = Color.AMBER_BRIGHT,
	hint_fg = Color.BLUE_DEEP,
	hint_bg = Color.BLUE_BRIGHT,
	info_fg = Color.BLUE_DEEP,
	info_bg = Color.BLUE_BRIGHT,

	-- Diff
	add = { fg = Color.BLUE_DEEP, bg = Color.BLUE_BRIGHT },
	del = { fg = Color.RED_DEEP, bg = Color.RED_BRIGHT },
	change = { fg = Color.AMBER_DEEP, bg = Color.AMBER_BRIGHT },
	-- Inverted rather than brightened: on light there is no amber above
	-- AMBER_BRIGHT to escalate into, so flip the block instead.
	change_strong = { fg = Color.AMBER_BRIGHT, bg = Color.AMBER_DEEP, bold = true },

	-- UI chrome
	-- NEUTRAL_300 would be "correct" by hierarchy (border dimmer than fg_dim,
	-- as on dark) but lands at 1.4:1 — an invisible FloatBorder. Shares fg_dim's
	-- value instead; both are recede-roles, so the collision is harmless.
	border = Color.NEUTRAL_400,
	status = { fg = Color.NEUTRAL_700, bg = "NONE" },
}

-- Both variants must define exactly the same keys. Falling back to the other
-- variant's value would paint a dark colour onto a light background: a silently
-- wrong render in whichever variant you aren't currently looking at. Fail at
-- load time instead, naming the key.
local function check_parity(a, b, a_name, b_name, path)
	path = path or ""
	for k, v in pairs(a) do
		if b[k] == nil then
			error(("fundament: `%s` defines `%s%s`, `%s` does not"):format(a_name, path, k, b_name), 0)
		elseif type(v) ~= type(b[k]) then
			error(("fundament: `%s%s` is %s in `%s` but %s in `%s`"):format(path, k, type(v), a_name, type(b[k]), b_name), 0)
		elseif type(v) == "table" then
			check_parity(v, b[k], a_name, b_name, path .. k .. ".")
		end
	end
end
check_parity(dark, light, "dark", "light")
check_parity(light, dark, "light", "dark")

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
hi(0, "Cursor", { fg = c.bg, bg = c.fg_strong })
hi(0, "lCursor", { link = "Cursor" })
hi(0, "TermCursor", { link = "Cursor" })
hi(0, "CursorLine", { bg = c.bg_subtle })
hi(0, "CursorColumn", { bg = c.bg_subtle })
hi(0, "ColorColumn", { bg = c.bg_subtle })
-- Current line number must be brighter than LineNr, not dimmer
hi(0, "CursorLineNr", { fg = c.fg, bg = c.bg_subtle, bold = true })
hi(0, "LineNr", { fg = c.fg_dim })
hi(0, "LineNrAbove", { link = "LineNr" })
hi(0, "LineNrBelow", { link = "LineNr" })
hi(0, "SignColumn", { fg = c.fg_dim, bg = c.bg })
hi(0, "CursorLineSign", { bg = c.bg_subtle })
hi(0, "CursorLineFold", { bg = c.bg_subtle })
hi(0, "Visual", c.visual)
hi(0, "VisualNOS", { link = "Visual" })
hi(0, "CurSearch", c.cursearch)
hi(0, "Search", c.search)
hi(0, "IncSearch", { link = "CurSearch" })
hi(0, "Substitute", { link = "CurSearch" })
hi(0, "MatchParen", { fg = c.accent, bg = c.bg_subtle, bold = true })
hi(0, "CursorWord", { bg = c.bg_subtle }) -- if using nvim-cursorword

-- Syntax
-- Comments equal weight to code — intentional
hi(0, "Comment", { fg = c.fg })
-- Punctuation recedes; operators stay readable (semantic weight)
hi(0, "Delimiter", { fg = c.fg_dim })
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
hi(0, "SpecialKey", { fg = c.fg_dim })
hi(0, "Statement", { fg = c.fg })
hi(0, "Underlined", { fg = c.fg, underline = true })
hi(0, "Directory", { fg = c.fg })
hi(0, "Todo", { fg = c.fg_strong, bold = true })
hi(0, "Error", { fg = c.error_fg, bg = c.error_bg })

-- Definitions pop (LSP-driven alternatives exist — see below)
hi(0, "Title", { fg = c.fg_strong, bold = true })

-- UI structure
hi(0, "WinSeparator", { fg = c.border })
hi(0, "FloatBorder", { fg = c.border, bg = c.bg })
hi(0, "FloatTitle", { fg = c.fg_strong, bg = c.bg, bold = true })
hi(0, "FloatFooter", { fg = c.fg_dim, bg = c.bg })
hi(0, "Pmenu", { fg = c.fg, bg = c.bg })
hi(0, "PmenuSel", { fg = c.fg_strong, bg = c.visual.bg, bold = true })
hi(0, "PmenuSbar", { bg = c.bg_subtle })
hi(0, "PmenuThumb", { bg = c.fg_dim })
hi(0, "PmenuMatch", { fg = c.accent })
hi(0, "PmenuMatchSel", { fg = c.accent, bg = c.visual.bg, bold = true })
hi(0, "WildMenu", { link = "PmenuSel" })

-- Non-text: folds, filler, whitespace — structure, so it recedes
hi(0, "NonText", { fg = c.fg_dim })
hi(0, "EndOfBuffer", { link = "NonText" })
hi(0, "Whitespace", { fg = c.fg_dim })
hi(0, "Conceal", { fg = c.fg_dim })
hi(0, "Folded", { fg = c.fg_dim, bg = c.bg_subtle })
hi(0, "FoldColumn", { fg = c.fg_dim, bg = c.bg })

-- Messages
hi(0, "MsgArea", { fg = c.fg, bg = c.bg })
hi(0, "MsgSeparator", { fg = c.border, bg = c.bg })
hi(0, "ModeMsg", { fg = c.fg, bold = true })
hi(0, "MoreMsg", { fg = c.fg })
hi(0, "Question", { fg = c.fg })
hi(0, "ErrorMsg", { fg = c.error_fg })
hi(0, "WarningMsg", { fg = c.warn_fg })

-- Spelling: undercurl carries the signal, hue stays reserved
hi(0, "SpellBad", { sp = c.error_fg, undercurl = true })
hi(0, "SpellCap", { sp = c.hint_fg, undercurl = true })
hi(0, "SpellLocal", { sp = c.hint_fg, undercurl = true })
hi(0, "SpellRare", { sp = c.hint_fg, undercurl = true })

-- Tabs & winbar
hi(0, "TabLine", { fg = c.fg_dim, bg = c.bg })
hi(0, "TabLineSel", { fg = c.fg_strong, bg = c.bg_subtle, bold = true })
hi(0, "TabLineFill", { bg = c.bg })
hi(0, "WinBar", { fg = c.fg, bg = c.bg })
hi(0, "WinBarNC", { fg = c.fg_dim, bg = c.bg })

-- Quickfix
hi(0, "QuickFixLine", { bg = c.bg_subtle, bold = true })

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
hi(0, "DiagnosticOk", { fg = c.fg })
hi(0, "DiagnosticUnderlineError", { sp = c.error_fg, undercurl = true })
hi(0, "DiagnosticUnderlineWarn", { sp = c.warn_fg, undercurl = true })
hi(0, "DiagnosticUnderlineHint", { sp = c.hint_fg, undercurl = true })
hi(0, "DiagnosticUnderlineInfo", { sp = c.info_fg, undercurl = true })
hi(0, "DiagnosticVirtualTextError", { fg = c.error_fg, bg = c.error_bg })
hi(0, "DiagnosticVirtualTextWarn", { fg = c.warn_fg, bg = c.warn_bg })
hi(0, "DiagnosticVirtualTextHint", { fg = c.hint_fg, bg = c.hint_bg })
hi(0, "DiagnosticVirtualTextInfo", { fg = c.info_fg, bg = c.info_bg })
hi(0, "DiagnosticSignError", { link = "DiagnosticError" })
hi(0, "DiagnosticSignWarn", { link = "DiagnosticWarn" })
hi(0, "DiagnosticSignHint", { link = "DiagnosticHint" })
hi(0, "DiagnosticSignInfo", { link = "DiagnosticInfo" })
hi(0, "DiagnosticDeprecated", { fg = c.fg_dim, strikethrough = true })
hi(0, "DiagnosticUnnecessary", { fg = c.fg_dim })

-- Markup
hi(0, "@markup", { fg = c.fg })
hi(0, "@markup.strong", { bold = true })
hi(0, "@markup.italic", { italic = true })
hi(0, "@markup.strikethrough", { strikethrough = true })
hi(0, "@markup.underline", { underline = true })
hi(0, "@markup.heading", { fg = c.fg_strong, bold = true })
hi(0, "@markup.heading.markdown", { fg = c.fg_strong, bold = true })
hi(0, "@markup.math", { fg = c.fg })
hi(0, "@markup.quote", { fg = c.fg, italic = true })
hi(0, "@markup.environment", { fg = c.fg })
hi(0, "@markup.environment.name", { fg = c.fg })
hi(0, "@markup.link", { fg = c.fg, underline = true })
hi(0, "@markup.link.label", { fg = c.fg, underline = true })
hi(0, "@markup.link.url", { fg = c.fg_dim, italic = true, underline = true })
hi(0, "@markup.raw", { fg = c.literal })
hi(0, "@markup.list", { fg = c.fg })
hi(0, "@markup.list.checked", { fg = c.fg_dim })
hi(0, "@markup.list.unchecked", { fg = c.fg })

-- Diff
hi(0, "DiffAdd", c.add)
hi(0, "DiffDelete", c.del)
hi(0, "DiffChange", c.change)
hi(0, "DiffText", c.change_strong)
-- Gitsigns / statusline conventions
hi(0, "Added", { fg = c.add.fg })
hi(0, "Removed", { fg = c.del.fg })
hi(0, "Changed", { fg = c.change.fg })

-- Treesitter (add as :Inspect surfaces them)
-- These override legacy groups in modern configs — don't neglect them
hi(0, "@comment", { link = "Comment" })
hi(0, "@comment.documentation", { link = "Comment" })
hi(0, "@punctuation", { fg = c.fg_dim })
hi(0, "@punctuation.bracket", { fg = c.fg_dim })
hi(0, "@punctuation.delimiter", { fg = c.fg_dim })
hi(0, "@string", { link = "String" })
hi(0, "@number", { link = "Number" })
hi(0, "@boolean", { link = "Boolean" })
-- Everything else links to Normal until you decide otherwise
hi(0, "@variable", { fg = c.fg_strong })
hi(0, "@variable.parameter", { fg = c.accent })
hi(0, "@constant.builtin", { link = "Constant" })
hi(0, "@function", { fg = c.fg })
hi(0, "@keyword", { link = "Keyword" })
hi(0, "@type", { fg = c.fg, italic = true })

-- LSP semantic tokens (commonly missed — causes inconsistency)
-- Uncomment and adjust as :Inspect surfaces them
-- hi(0, "@lsp.type.function",  { fg = c.fg })
-- hi(0, "@lsp.type.variable",  { fg = c.fg })
-- hi(0, "@lsp.type.keyword",   { fg = c.fg })
hi(0, "@lsp.type.parameter", { fg = c.accent })

-- LSP document highlight (dynamic — highlights all refs to symbol under cursor)
-- This can replace static definition highlighting
hi(0, "LspReferenceText", { bg = c.bg_subtle })
hi(0, "LspReferenceRead", { bg = c.bg_subtle })
hi(0, "LspReferenceWrite", { bg = c.bg_subtle, bold = true })

-- ============================================================
-- BACKGROUND TOGGLE AUTOCMD
-- Re-applies theme when :set background=light/dark is called.
-- Named group + clear so re-sourcing replaces the autocmd instead of stacking
-- copies (this file re-sources itself from inside the callback).
-- ============================================================
local group = vim.api.nvim_create_augroup("FundamentBackground", { clear = true })
vim.api.nvim_create_autocmd("OptionSet", {
	group = group,
	pattern = "background",
	callback = function()
		vim.cmd("colorscheme fundament")
	end,
})
