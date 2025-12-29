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
config.command_palette_fg_color = "#B1B9D9"
config.command_palette_bg_color = "#1D1F30"
config.command_palette_font_size = 16.0

config.tab_bar_at_bottom = true
config.leader = { key = "b", mods = "CTRL" }

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

config.keys = {
	-- tmux-like controls
	-- Window management
	{ key = "a", mods = "LEADER", action = act({ SendString = "`" }) },
	-- {key="-",  mods="LEADER", action=act{SplitVertical={domain="CurrentPaneDomain"}} },
	-- {key="\\", mods="LEADER", action=act.SplitHorizontal{domain="CurrentPaneDomain"}},
	-- { key = "z", mods = "LEADER", action = "TogglePaneZoomState" },
	{ key = "c", mods = "LEADER", action = act({ SpawnTab = "CurrentPaneDomain" }) },
	{ key = "d", mods = "LEADER", action = act.CloseCurrentTab({ confirm = true }) },
	{ key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{ key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
	{ key = "N", mods = "LEADER", action = act.MoveTabRelative(1) },
	{ key = "P", mods = "LEADER", action = act.MoveTabRelative(-1) },

	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },

	{ key = "H", mods = "LEADER", action = act({ AdjustPaneSize = { "Left", 5 } }) },
	{ key = "J", mods = "LEADER", action = act({ AdjustPaneSize = { "Down", 5 } }) },
	{ key = "K", mods = "LEADER", action = act({ AdjustPaneSize = { "Up", 5 } }) },
	{ key = "L", mods = "LEADER", action = act({ AdjustPaneSize = { "Right", 5 } }) },

	{ key = "`", mods = "LEADER", action = act.ActivateLastTab },
	{ key = " ", mods = "LEADER", action = act.ActivateTabRelative(1) },
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
	-- tmux sessionizer equivalent
	{
		key = "f",
		mods = "LEADER",
		action = wezterm.action_callback(function(window, pane)
			local home = wezterm.home_dir
			local base_dirs =
				{ home .. "/dev/work", home .. "/dev/private", home .. "/dev/work/gitlab", home, home .. "/.config" }
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
return config
