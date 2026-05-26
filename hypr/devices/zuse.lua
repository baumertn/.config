-- Config for `zuse`; personal laptop Lenovo ThinkPad T495

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
-- End Monitors =================================================================

-- Autostart ====================================================================
hl.on("hyprland.start", function()
	hl.exec_cmd("kdeconnectd")
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
-- End Device settings ----------------------------------------------------------
-- End Input ====================================================================
