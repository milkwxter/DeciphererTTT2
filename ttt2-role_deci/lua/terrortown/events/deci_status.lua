if CLIENT then
	hook.Add("Initialize", "ttt2_deci_init", function()
		STATUS:RegisterStatus("ttt2_deci_cooldown_stat", {
			hud = Material("vgui/ttt/icons/charging.png"),
			type = "bad",
			name = "Minitester charging cooldown",
			sidebarDescription = "You cannot decipher roles until your minitester is charged again."
		})
	end)
end