if SERVER then
	AddCSLuaFile()
	
	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_deci.vmt")
	
	-- server only convars
	CreateConVar("ttt2_decipherer_max_uses", 3, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Max uses for minitester?", 1, 10)
	CreateConVar("ttt2_decipherer_destroy_on_traitor", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Destroy minitester when finding a traitor?", 0, 1)
	CreateConVar("ttt2_decipherer_discombob_on_traitor", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Discombobulate Decipherer when finding a traitor?", 0, 1)
	CreateConVar("ttt2_decipherer_smoke_on_traitor", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Smoke bomb Decipherer when finding a traitor?", 0, 1)
end

-- shared convars
CreateConVar("ttt2_decipherer_max_charge", 100, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "How much charge does the minitester need to work?", 10, 200)
CreateConVar("ttt2_decipherer_start_charge_pct", 50, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Percent of charge the minitester starts with?", 0, 100)
CreateConVar("ttt2_decipherer_max_uses_enabled", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Should the minitester have a limit to uses?", 0, 1)

function ROLE:PreInitialize()
	self.color = Color(31, 77, 191, 255)

	self.abbr = "deci"

	self.defaultTeam = TEAM_INNOCENT
	self.defaultEquipment = SPECIAL_EQUIPMENT
	
	self.score.killsMultiplier = 8
	self.score.teamKillsMultiplier = -8
	self.score.bodyFoundMuliplier = 3
	self.unknownTeam = true

	self.isPublicRole = true
	self.isPolicingRole = true

	self.conVarData = {
		pct = 0.13,
		maximum = 1,
		minPlayers = 8,
		minKarma = 800,
		
		credits = 1,
		creditsAwardDeadEnable = 1,
		creditsAwardKillEnable = 0,
		
		togglable = true,
		random = 25,
		shopFallback = SHOP_FALLBACK_DETECTIVE
	}
end

function ROLE:Initialize()
	roles.SetBaseRole(self, ROLE_DETECTIVE)
end

if SERVER then
	-- give loadout on respawn and rolechange
	function ROLE:GiveRoleLoadout(ply, isRoleChange)
		ply:GiveEquipmentWeapon("weapon_ttt2_decitester")
		ply:GiveEquipmentItem("item_ttt_armor")
	end

	-- remove loadout on death and rolechange
	function ROLE:RemoveRoleLoadout(ply, isRoleChange)
		ply:StripWeapon("weapon_ttt2_decitester")
		ply:RemoveEquipmentItem("item_ttt_armor")
	end
end

-- convars
if CLIENT then
    function ROLE:AddToSettingsMenu(parent)
        local form = vgui.CreateTTT2Form(parent, "header_roles_additional")
		
		form:MakeSlider({
			serverConvar = "ttt2_decipherer_max_charge",
			label = "ttt2_label_decipherer_max_charge",
			min = 10,
			max = 200,
			decimal = 0,
		})
		
		form:MakeSlider({
			serverConvar = "ttt2_decipherer_start_charge_pct",
			label = "ttt2_label_decipherer_start_charge_pct",
			min = 0,
			max = 100,
			decimal = 0,
		})
		
		local maxUseMaster = form:MakeCheckBox({
			serverConvar = "ttt2_decipherer_max_uses_enabled",
			label = "ttt2_label_decipherer_max_uses_enabled",
			min = 0,
			max = 1,
			decimal = 0,
		})
		
		form:MakeSlider({
			serverConvar = "ttt2_decipherer_max_uses",
			label = "ttt2_label_decipherer_max_uses",
			min = 1,
			max = 10,
			decimal = 0,
			master = maxUseMaster,
		})
		
		form:MakeCheckBox({
			serverConvar = "ttt2_decipherer_destroy_on_traitor",
			label = "ttt2_label_decipherer_destroy_on_traitor",
			min = 0,
			max = 1,
			decimal = 0,
		})
		
		form:MakeCheckBox({
			serverConvar = "ttt2_decipherer_discombob_on_traitor",
			label = "ttt2_label_decipherer_discombob_on_traitor",
			min = 0,
			max = 1,
			decimal = 0,
		})
		
		form:MakeCheckBox({
			serverConvar = "ttt2_decipherer_smoke_on_traitor",
			label = "ttt2_label_decipherer_smoke_on_traitor",
			min = 0,
			max = 1,
			decimal = 0,
		})
    end
end
