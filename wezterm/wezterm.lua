local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

-- config.font = wezterm.font("JetBrains Mono")
config.font_size = 16.0

local function get_appearance()
	-- gui may not be available.
	if wezterm.gui then
		return wezterm.gui.get_appearance()
	end
	return "Dark"
end

local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "3024 (dark) (terminal.sexy)"
	else
		return "3024 (light) (terminal.sexy)"
	end
end

config.color_scheme = scheme_for_appearance(get_appearance())
config.colors = {
	cursor_bg = "#D4D4D4", -- cursor body
	cursor_border = "#ffffff", -- outline (block/box cursor)
	cursor_fg = "#000000", -- text under the cursor
}

config.default_prog = { "/usr/bin/fish", "-l" }

-- default is true, has more "native" look
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

config.enable_scroll_bar = true
config.window_padding = {
	left = 5,
	right = 5,
	top = 0,
	bottom = 0,
}
-- config.command_palette_fg_color = "#AAAAAA"
-- config.command_palette_bg_color = "#000000"
config.command_palette_font_size = 16.0

config.tab_bar_at_bottom = true
config.leader = { key = "Space", mods = "ALT", timeout_milliseconds = 1000 }

-- tmux sessionizer equivalent

-- Function to execute a command and return its output as a table
local function execute_command(cmd)
	local handle = io.popen(cmd)
	local result = handle:read("*a")
	handle:close()

	local lines = {}
	for line in result:gmatch("[^\r\n]+") do
		table.insert(lines, line)
	end

	return lines
end
local function sessionizer(base_dirs, min_depth, max_depth)
	local directories = {}
	for _, base_dir in ipairs(base_dirs) do
		local command = string.format("find %s -mindepth %d -maxdepth %d -type d", base_dir, min_depth, max_depth)
		local dirs = execute_command(command)

		for _, dir in ipairs(dirs) do
			table.insert(directories, { id = dir, label = dir:match("^.+/(.+)$"):gsub("%.", "_") })
		end
	end
	return directories
end

-- Pane navigation lives on plain ALT so it costs one chord, not two.
-- ALT is free: nvim binds no <M-*>, hyprland uses SUPER, fish has no custom binds.
local function pane_nav(key, dir)
	return { key = key, mods = "ALT", action = act.ActivatePaneDirection(dir) }
end

config.keys = {
	-- Leader is ALT+Space, so apps never see it; this sends a literal one through.
	{ key = "a", mods = "LEADER", action = act.SendKey({ key = "Space", mods = "ALT" }) },

	-- Pane navigation: direct, no prefix
	pane_nav("h", "Left"),
	pane_nav("j", "Down"),
	pane_nav("k", "Up"),
	pane_nav("l", "Right"),

	-- One-off resize nudges; LEADER r enters resize mode for sustained work
	{ key = "H", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Left", 3 }) },
	{ key = "J", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Down", 3 }) },
	{ key = "K", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Up", 3 }) },
	{ key = "L", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Right", 3 }) },

	-- Splits: ALT for speed, LEADER for tmux muscle memory
	{ key = "\\", mods = "ALT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "-", mods = "ALT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "\\", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

	{ key = "z", mods = "ALT", action = act.TogglePaneZoomState },
	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },

	-- Label picker: jump anywhere in a complex layout without directional hopping
	{ key = "w", mods = "ALT", action = act.PaneSelect({ alphabet = "asdfghjkl" }) },
	{ key = "Space", mods = "LEADER", action = act.PaneSelect({ alphabet = "asdfghjkl" }) },
	{ key = "S", mods = "LEADER", action = act.PaneSelect({ mode = "SwapWithActive", alphabet = "asdfghjkl" }) },

	{ key = "o", mods = "LEADER", action = act.ActivatePaneDirection("Next") },
	{ key = ";", mods = "LEADER", action = act.ActivatePaneDirection("Prev") },
	{ key = "{", mods = "LEADER", action = act.RotatePanes("CounterClockwise") },
	{ key = "}", mods = "LEADER", action = act.RotatePanes("Clockwise") },

	-- Modal tables: repeatable without re-pressing leader
	{ key = "r", mods = "LEADER", action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }) },
	{ key = "m", mods = "LEADER", action = act.ActivateKeyTable({ name = "move_tab", one_shot = false }) },

	-- Tabs
	{ key = "c", mods = "LEADER", action = act({ SpawnTab = "CurrentPaneDomain" }) },
	{ key = "d", mods = "LEADER", action = act.CloseCurrentTab({ confirm = true }) },
	{ key = "[", mods = "ALT", action = act.ActivateTabRelative(-1) },
	{ key = "]", mods = "ALT", action = act.ActivateTabRelative(1) },
	{ key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{ key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
	{ key = "N", mods = "LEADER", action = act.MoveTabRelative(1) },
	{ key = "P", mods = "LEADER", action = act.MoveTabRelative(-1) },

	{
		key = ",",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = "New tab title",
			action = wezterm.action_callback(function(window, _, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},

	-- Switch between existing workspaces (LEADER f below only creates them)
	{ key = "w", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
	{
		key = "$",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = "Rename workspace",
			action = wezterm.action_callback(function(_, _, line)
				if line then
					wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
				end
			end),
		}),
	},

	{ key = "`", mods = "LEADER", action = act.ActivateLastTab },
	{ key = "1", mods = "LEADER", action = act({ ActivateTab = 0 }) },
	{ key = "2", mods = "LEADER", action = act({ ActivateTab = 1 }) },
	{ key = "3", mods = "LEADER", action = act({ ActivateTab = 2 }) },
	{ key = "4", mods = "LEADER", action = act({ ActivateTab = 3 }) },
	{ key = "5", mods = "LEADER", action = act({ ActivateTab = 4 }) },
	{ key = "6", mods = "LEADER", action = act({ ActivateTab = 5 }) },
	{ key = "7", mods = "LEADER", action = act({ ActivateTab = 6 }) },
	{ key = "8", mods = "LEADER", action = act({ ActivateTab = 7 }) },
	{ key = "9", mods = "LEADER", action = act({ ActivateTab = 8 }) },
	{ key = "x", mods = "LEADER", action = act({ CloseCurrentPane = { confirm = true } }) },

	-- Activate Copy Mode
	{ key = "[", mods = "LEADER", action = act.ActivateCopyMode },
	-- Paste from Copy Mode
	{ key = "]", mods = "LEADER", action = act.PasteFrom("PrimarySelection") },
	{ key = "/", mods = "LEADER", action = act.Search({ CaseInSensitiveString = "" }) },
	{
		key = "u",
		mods = "LEADER",
		action = act.QuickSelectArgs({
			label = "open url",
			patterns = { "https?://\\S+" },
			action = wezterm.action_callback(function(window, pane)
				wezterm.open_with(window:get_selection_text_for_pane(pane))
			end),
		}),
	},
	-- tmux sessionizer equivalent
	{
		key = "f",
		mods = "LEADER",
		action = wezterm.action_callback(function(window, pane)
			local home = wezterm.home_dir
			local base_dirs = {
				home .. "/dev",
				home .. "/dev/work",
				home .. "/dev/private",
				home .. "/dev/work/gitlab",
				home .. "/.config",
				home,
			}
			local workspaces = sessionizer(base_dirs, 1, 1)

			window:perform_action(
				act.InputSelector({
					action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
						if not id and not label then
							wezterm.log_info("cancelled")
						else
							wezterm.log_info("id = " .. id)
							wezterm.log_info("label = " .. label)
							inner_window:perform_action(
								act.SwitchToWorkspace({
									name = label,
									spawn = {
										label = "Workspace: " .. label,
										cwd = id,
									},
								}),
								inner_pane
							)
						end
					end),
					title = "Choose Workspace",
					choices = workspaces,
					fuzzy = true,
					fuzzy_description = "Fuzzy find and/or make a workspace ",
				}),
				pane
			)
		end),
	},
}

config.key_tables = {
	-- Sustained resizing: LEADER r, then hjkl as often as needed, Esc/q/Enter to leave.
	resize_pane = {
		{ key = "h", action = act.AdjustPaneSize({ "Left", 3 }) },
		{ key = "j", action = act.AdjustPaneSize({ "Down", 3 }) },
		{ key = "k", action = act.AdjustPaneSize({ "Up", 3 }) },
		{ key = "l", action = act.AdjustPaneSize({ "Right", 3 }) },
		{ key = "LeftArrow", action = act.AdjustPaneSize({ "Left", 3 }) },
		{ key = "DownArrow", action = act.AdjustPaneSize({ "Down", 3 }) },
		{ key = "UpArrow", action = act.AdjustPaneSize({ "Up", 3 }) },
		{ key = "RightArrow", action = act.AdjustPaneSize({ "Right", 3 }) },
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "q", action = "PopKeyTable" },
		{ key = "Enter", action = "PopKeyTable" },
	},

	-- Tab reordering: LEADER m, then h/l (or j/k), Esc/q/Enter to leave.
	move_tab = {
		{ key = "h", action = act.MoveTabRelative(-1) },
		{ key = "l", action = act.MoveTabRelative(1) },
		{ key = "j", action = act.MoveTabRelative(-1) },
		{ key = "k", action = act.MoveTabRelative(1) },
		{ key = "LeftArrow", action = act.MoveTabRelative(-1) },
		{ key = "RightArrow", action = act.MoveTabRelative(1) },
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "q", action = "PopKeyTable" },
		{ key = "Enter", action = "PopKeyTable" },
	},

	-- added new shortcuts to the end
	copy_mode = {
		{ key = "c", mods = "CTRL", action = act.CopyMode("Close") },
		{ key = "g", mods = "CTRL", action = act.CopyMode("Close") },
		{ key = "q", mods = "NONE", action = act.CopyMode("Close") },
		{ key = "Escape", mods = "NONE", action = act.CopyMode("Close") },

		{ key = "h", mods = "NONE", action = act.CopyMode("MoveLeft") },
		{ key = "j", mods = "NONE", action = act.CopyMode("MoveDown") },
		{ key = "k", mods = "NONE", action = act.CopyMode("MoveUp") },
		{ key = "l", mods = "NONE", action = act.CopyMode("MoveRight") },

		{ key = "LeftArrow", mods = "NONE", action = act.CopyMode("MoveLeft") },
		{ key = "DownArrow", mods = "NONE", action = act.CopyMode("MoveDown") },
		{ key = "UpArrow", mods = "NONE", action = act.CopyMode("MoveUp") },
		{ key = "RightArrow", mods = "NONE", action = act.CopyMode("MoveRight") },

		{ key = "RightArrow", mods = "ALT", action = act.CopyMode("MoveForwardWord") },
		{ key = "f", mods = "ALT", action = act.CopyMode("MoveForwardWord") },
		{ key = "Tab", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
		{ key = "w", mods = "NONE", action = act.CopyMode("MoveForwardWord") },

		{ key = "LeftArrow", mods = "ALT", action = act.CopyMode("MoveBackwardWord") },
		{ key = "b", mods = "ALT", action = act.CopyMode("MoveBackwardWord") },
		{ key = "Tab", mods = "SHIFT", action = act.CopyMode("MoveBackwardWord") },
		{ key = "b", mods = "NONE", action = act.CopyMode("MoveBackwardWord") },

		{ key = "0", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
		{ key = "Enter", mods = "NONE", action = act.CopyMode("MoveToStartOfNextLine") },

		{ key = "$", mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent") },
		{ key = "$", mods = "SHIFT", action = act.CopyMode("MoveToEndOfLineContent") },
		{ key = "^", mods = "NONE", action = act.CopyMode("MoveToStartOfLineContent") },
		{ key = "^", mods = "SHIFT", action = act.CopyMode("MoveToStartOfLineContent") },
		{ key = "m", mods = "ALT", action = act.CopyMode("MoveToStartOfLineContent") },

		{ key = " ", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
		{ key = "v", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
		{ key = "V", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Line" }) },
		{ key = "V", mods = "SHIFT", action = act.CopyMode({ SetSelectionMode = "Line" }) },
		{ key = "v", mods = "CTRL", action = act.CopyMode({ SetSelectionMode = "Block" }) },

		{ key = "G", mods = "NONE", action = act.CopyMode("MoveToScrollbackBottom") },
		{ key = "G", mods = "SHIFT", action = act.CopyMode("MoveToScrollbackBottom") },
		{ key = "g", mods = "NONE", action = act.CopyMode("MoveToScrollbackTop") },

		{ key = "H", mods = "NONE", action = act.CopyMode("MoveToViewportTop") },
		{ key = "H", mods = "SHIFT", action = act.CopyMode("MoveToViewportTop") },
		{ key = "M", mods = "NONE", action = act.CopyMode("MoveToViewportMiddle") },
		{ key = "M", mods = "SHIFT", action = act.CopyMode("MoveToViewportMiddle") },
		{ key = "L", mods = "NONE", action = act.CopyMode("MoveToViewportBottom") },
		{ key = "L", mods = "SHIFT", action = act.CopyMode("MoveToViewportBottom") },

		{ key = "o", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEnd") },
		{ key = "O", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
		{ key = "O", mods = "SHIFT", action = act.CopyMode("MoveToSelectionOtherEndHoriz") },

		{ key = "PageUp", mods = "NONE", action = act.CopyMode("PageUp") },
		{ key = "PageDown", mods = "NONE", action = act.CopyMode("PageDown") },

		{ key = "b", mods = "CTRL", action = act.CopyMode("PageUp") },
		{ key = "f", mods = "CTRL", action = act.CopyMode("PageDown") },

		-- Enter y to copy and quit the copy mode.
		{
			key = "y",
			mods = "NONE",
			action = act.Multiple({
				act.CopyTo("ClipboardAndPrimarySelection"),
				act.CopyMode("Close"),
			}),
		},
		-- Enter search mode to edit the pattern.
		-- When the search pattern is an empty string the existing pattern is preserved
		{ key = "/", mods = "NONE", action = act({ Search = { CaseSensitiveString = "" } }) },
		{ key = "?", mods = "NONE", action = act({ Search = { CaseInSensitiveString = "" } }) },
		{ key = "n", mods = "CTRL", action = act({ CopyMode = "NextMatch" }) },
		{ key = "p", mods = "CTRL", action = act({ CopyMode = "PriorMatch" }) },
	},

	search_mode = {
		{ key = "Escape", mods = "NONE", action = act({ CopyMode = "Close" }) },
		-- Go back to copy mode when pressing enter, so that we can use unmodified keys like "n"
		-- to navigate search results without conflicting with typing into the search area.
		{ key = "Enter", mods = "NONE", action = "ActivateCopyMode" },
		{ key = "c", mods = "CTRL", action = "ActivateCopyMode" },
		{ key = "n", mods = "CTRL", action = act({ CopyMode = "NextMatch" }) },
		{ key = "p", mods = "CTRL", action = act({ CopyMode = "PriorMatch" }) },
		{ key = "r", mods = "CTRL", action = act.CopyMode("CycleMatchType") },
		{ key = "u", mods = "CTRL", action = act.CopyMode("ClearPattern") },
	},
}

-- Show which key table is active so modal mode is never invisible.
-- Explicit fg/bg: the tab bar's default status color is too low-contrast to read.
wezterm.on("update-right-status", function(window, _)
	local name = window:active_key_table()
	if not name then
		window:set_right_status("")
		return
	end
	window:set_right_status(wezterm.format({
		{ Background = { Color = "#db7b26" } },
		{ Foreground = { Color = "#090300" } },
		{ Attribute = { Intensity = "Bold" } },
		{ Text = " " .. name:upper() .. " " },
		{ Background = { Color = "none" } },
		{ Foreground = { Color = "none" } },
		{ Attribute = { Intensity = "Normal" } },
		{ Text = " " },
	}))
end)

return config
