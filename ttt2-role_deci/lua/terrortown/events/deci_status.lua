if SERVER then
	-- Add icons to clients machines
	resource.AddFile("materials/vgui/ttt/icons/charging.png")
	resource.AddFile("materials/vgui/ttt/icons/timer.png")

	-- Getting ready to accept this string
	util.AddNetworkString("ttt2_deci_hit_ply")

	-- When this string is broadcasted, we write important info that only the server has
	hook.Add("TTTGetDeciPly","ttt_get_deci_ply",function(arg)
		net.Start("ttt2_deci_hit_ply")
		net.WriteString(arg:GetRoleString())
		net.WriteColor(arg:GetRoleColor())
		net.Broadcast()
	end)
end

-- These are the status conditions found in the role
if CLIENT then
	hook.Add("Initialize", "ttt2_deci_init", function()
		-- Decipherer's Charging Cooldown
		STATUS:RegisterStatus("ttt2_deci_cooldown_stat", {
			hud = Material("vgui/ttt/icons/charging.png"),
			type = "bad",
			name = "lang_deci_status_charging",
			sidebarDescription = "lang_deci_status_charging_desc"
		})

		-- Decipherer's Minitester Result Timer
		STATUS:RegisterStatus("ttt2_deci_results_timer_stat", {
			hud = Material("vgui/ttt/icons/timer.png"),
			type = "good",
			name = "lang_deci_status_timer",
			sidebarDescription = "lang_deci_status_timer_desc"
		})
	end)
end