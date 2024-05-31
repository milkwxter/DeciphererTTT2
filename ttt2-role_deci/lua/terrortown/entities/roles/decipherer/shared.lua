if SERVER then
	AddCSLuaFile()

	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_deci.vmt")
end

function ROLE:PreInitialize()
	self.color = Color(67, 64, 138, 255)

	self.abbr = "deci"
	self.score.killsMultiplier = 8
	self.score.teamKillsMultiplier = -8
	self.score.bodyFoundMuliplier = 3
	self.unknownTeam = true

	self.defaultTeam = TEAM_INNOCENT
	self.defaultEquipment = SPECIAL_EQUIPMENT

	self.isPublicRole = true
	self.isPolicingRole = true

	self.conVarData = {
		pct = 0.13,
		maximum = 1,
		minPlayers = 6,
		minKarma = 600,
		credits = 2,
		creditsAwardDeadEnable = 1,
		creditsAwardKillEnable = 0,
		togglable = true,
		random = 33,
		shopFallback = SHOP_FALLBACK_DETECTIVE
	}
end

function ROLE:Initialize()
	roles.SetBaseRole(self, ROLE_DETECTIVE)
end

if SERVER then
	-- Give Loadout on respawn and rolechange
	function ROLE:GiveRoleLoadout(ply, isRoleChange)
		ply:GiveEquipmentWeapon("weapon_ttt2_decitester")
		ply:GiveEquipmentItem("item_ttt_armor")
	end

	-- Remove Loadout on death and rolechange
	function ROLE:RemoveRoleLoadout(ply, isRoleChange)
		ply:StripWeapon("weapon_ttt2_decitester")
		ply:RemoveEquipmentItem("item_ttt_armor")
	end

	-- When round begins reset cooldowns to prevent funky business
	hook.Add("TTTBeginRound", "DeciBeginRound", function()
		timer.Remove("ttt2_decitester_results_timer")
		timer.Remove("ttt2_decitester_cooldown")
	end)
end

-- adding convars to the TTT2 menu
if CLIENT then
    function ROLE:AddToSettingsMenu(parent)
        local form = vgui.CreateTTT2Form(parent, "header_roles_additional")
		
        form:MakeSlider({
            serverConvar = "ttt2_decitester_charge_time",
            label = "label_decitester_charge_time",
            min = 10,
            max = 120,
            decimal = 0,
        })

		form:MakeSlider({
            serverConvar = "ttt2_decitester_confirm_time",
            label = "label_decitester_confirm_time",
            min = 5,
            max = 30,
            decimal = 0,
        })
    end
end