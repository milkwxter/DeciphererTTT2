if SERVER then
	AddCSLuaFile()

	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_deci.vmt")
end

function ROLE:PreInitialize()
	self.color = Color(1, 74, 66, 255)

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
		--ply:GiveEquipmentWeapon("weapon_ttt2_deputydeagle")
		ply:GiveEquipmentItem("item_ttt_armor")
	end

	-- Remove Loadout on death and rolechange
	function ROLE:RemoveRoleLoadout(ply, isRoleChange)
		--ply:StripWeapon("weapon_ttt2_deputydeagle")
		ply:RemoveEquipmentItem("item_ttt_armor")
	end
end