-- contrast audit for fundament
local function lum(rgb)
	local ch = {}
	for i, v in ipairs({ bit.rshift(rgb, 16) % 256, bit.rshift(rgb, 8) % 256, rgb % 256 }) do
		local s = v / 255
		ch[i] = s <= 0.03928 and s / 12.92 or ((s + 0.055) / 1.055) ^ 2.4
	end
	return 0.2126 * ch[1] + 0.7152 * ch[2] + 0.0722 * ch[3]
end
local function ratio(a, b)
	local la, lb = lum(a), lum(b)
	if la < lb then
		la, lb = lb, la
	end
	return (la + 0.05) / (lb + 0.05)
end

local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
local NBG = normal.bg
print(string.format("background=%s  Normal bg=#%06X", vim.o.background, NBG))
print(string.rep("-", 64))

local groups = {
	"Normal",
	"Comment",
	"Delimiter",
	"String",
	"Constant",
	"Title",
	"LineNr",
	"CursorLineNr",
	"NonText",
	"Directory",
	"@variable",
	"@variable.parameter",
	"@type",
	"DiagnosticError",
	"DiagnosticWarn",
	"DiagnosticHint",
	"DiagnosticVirtualTextError",
	"DiagnosticVirtualTextWarn",
	"DiagnosticVirtualTextHint",
	"Search",
	"CurSearch",
	"DiffAdd",
	"DiffDelete",
	"DiffChange",
	"DiffText",
	"PmenuSel",
	"Visual",
	"CursorLine",
	"WinSeparator",
	"FloatBorder",
	"ErrorMsg",
	"MatchParen",
	"Folded",
	"TabLineSel",
	"@markup.raw",
	"@markup.link.url",
}

local warned = 0
for _, g in ipairs(groups) do
	local h = vim.api.nvim_get_hl(0, { name = g, link = false })
	local fg, bg = h.fg, h.bg
	local eff_bg = bg or NBG
	local r = fg and ratio(fg, eff_bg) or nil
	local note = ""
	if bg and not fg then
		-- bg-only group: measure it against Normal fg and against page bg
		note = string.format("bg-only: text %.2f, vs page %.2f", ratio(normal.fg, bg), ratio(bg, NBG))
	elseif r then
		note = string.format("%.2f:1", r)
		if r < 3.0 then
			note = note .. "  <<< FAIL"
			warned = warned + 1
		elseif r < 4.5 then
			note = note .. "  << low (large/bold only)"
		end
	end
	print(
		string.format(
			"%-30s fg=%-8s bg=%-8s %s",
			g,
			fg and string.format("#%06X", fg) or "-",
			bg and string.format("#%06X", bg) or "-",
			note
		)
	)
end
print(string.rep("-", 64))
print("hard failures: " .. warned)
