if SERVER then
	resource.AddFile("materials/vgui/ttt/icons/charging.png")
	util.AddNetworkString("ttt2_deci_hit_ply")
end
-- 
if SERVER then
	hook.Add("TTTGetDeciPly","ttt_get_deci_ply",function(arg)
		net.Start("ttt2_deci_hit_ply")
		net.WriteString(arg:GetRoleString())
		net.WriteColor(arg:GetRoleColor())
		--LANG.MsgAll(arg:GetRoleString(), nil, MSG_MSTACK_WARN)
		net.Broadcast()
	end)
end
if CLIENT then
	hook.Add("Initialize", "ttt2_deci_init", function()
		-- Decipherer's Charging Cooldown
		STATUS:RegisterStatus("ttt2_deci_cooldown_stat", {
			hud = Material("vgui/ttt/icons/charging.png"),
			type = "bad",
			name = "Minitester charging cooldown",
			sidebarDescription = "You cannot decipher roles until your minitester is charged again."
		})

		-- Decipherer's Minitester Result Timer
		STATUS:RegisterStatus("ttt2_deci_results_timer_stat", {
			hud = Material("vgui/ttt/icons/timer.png"),
			type = "good",
			name = "Minitester results incoming",
			sidebarDescription = "When this timer hits 0, you will find out the player's role."
		})
	end)
end