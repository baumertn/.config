-- Config for `gamma`; desktop pc

-- Monitors =====================================================================
hl.monitor({
	output = "desc:ASR PGO32UFS HBCL0A000638",
	mode = "3840x2160@240.00Hz",
	position = "0x0",
	scale = "auto",
})
-- End Monitors =================================================================

-- Autostart ====================================================================
hl.on("hyprland.start", function()
	hl.exec_cmd("solaar -w hide") -- Solaar is for Logitech Devices
	hl.exec_cmd("kdeconnectd")
	-- hl.exec_cmd("[workspace special:magic] fooyin")
end)
-- End Autostart ================================================================

-- Input =======================================================================
-- Device settings --------------------------------------------------------------
hl.device({ -- Logitech G502 Gaming Mouse
	name = "logitech-g502-1",
	sensitivity = 1.0,
	accel_profile = "flat", -- No mouse acceleration
})
-- End Device settings ----------------------------------------------------------
-- End Input ====================================================================
