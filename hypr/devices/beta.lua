-- Config for `beta`; work laptop Lenovo ThinkPad E14

-- Monitors =====================================================================
hl.monitor({ -- Internal display
	output = "eDP-1",
	mode = "preffered",
	position = "0x0",
	scale = "auto",
})
hl.monitor({ -- External main display
	output = "desc:ASR PGO32UFS HBCL0A000638",
	mode = "3840x2160@240.00Hz",
	position = "0x-2160",
	scale = "auto",
})
-- Office monitors
hl.monitor({
	output = "desc:Samsung Electric Company LS27D80xU HK2XB00497",
	mode = "3840x2160@60.00Hz",
	position = "auto-left",
	scale = "1",
})
hl.monitor({
	output = "desc:Samsung Electric Company LS27D80xU HK2Y200073",
	mode = "3840x2160@60.00Hz",
	position = "auto-left",
	scale = "1",
})
-- End Monitors =================================================================

-- Autostart ====================================================================
hl.on("hyprland.start", function()
	hl.exec_cmd("nm-applet")
	hl.exec_cmd("[workspace special:magic] 1password")
end)
-- End Autostart ================================================================

-- Input =======================================================================
-- Device settings --------------------------------------------------------------
hl.device({
	name = "synps/2-synaptics-touchpad",
	sensitivity = 0,
})
hl.device({
	name = "tpps/2-elan-trackpoint",
	sensitivity = -0.5,
})
hl.device({
	name = "mosart-semi.-2.4g-input-device-mouse",
	sensitivity = -0.5,
})
-- End Device settings ----------------------------------------------------------
-- End Input ====================================================================
