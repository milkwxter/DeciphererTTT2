if SERVER then
	AddCSLuaFile()
	
	resource.AddFile("materials/vgui/ttt/icon_decitester.vmt")
	
	-- bum ass net messages
	util.AddNetworkString("TTT2_Decipherer_EPOP")
end

DEFINE_BASECLASS("weapon_tttbase")
SWEP.Base = "weapon_tttbase"

local DECITESTER_ERROR_NOT_PLAYER = 0
local DECITESTER_ERROR_LOST_TARGET = 1
local DECITESTER_ERROR_NO_USES = 2
local DECITESTER_ERROR_NOT_CHARGED = 3
local DECITESTER_MSG_READY = 4

local DECITESTER_IDLE = 0
local DECITESTER_BUSY = 1

local DECITESTER_FIRE_DELAY = 0.8

if CLIENT then
	SWEP.PrintName = "ttt2_label_decipherer_minitester_name"
	SWEP.Slot = 8
	
	SWEP.ViewModelFOV = 78
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFlip = false

	SWEP.EquipMenuData = {
		type = "item_weapon",
		name = "ttt2_label_decipherer_minitester_name",
		desc = "ttt2_label_decipherer_minitester_desc"
	}

	SWEP.Icon = "vgui/ttt/icon_decitester"
end

local sounds = {
    empty = Sound("Weapon_SMG1.Empty"),
    hum = Sound("items/nvg_on.wav"),
    zap = Sound("ambient/energy/zap7.wav"),
    charge = Sound("ambient/energy/newspark07.wav"),
    ready = Sound("buttons/button17.wav"),
	testFine = Sound("buttons/combine_button5.wav"),
	testEvil = Sound("buttons/button8.wav"),
}

SWEP.Kind = WEAPON_ROLE
SWEP.CanBuy = nil
SWEP.notBuyable = true

SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/v_c4.mdl"
SWEP.WorldModel = "models/weapons/w_c4.mdl"

SWEP.AutoSpawnable = false
SWEP.NoSights = true

SWEP.HoldType = "slam"

SWEP.Primary.Recoil = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Delay = 1

SWEP.Primary.ClipMax = -1
SWEP.Primary.ClipSize = GetConVar("ttt2_decipherer_max_charge"):GetInt()
SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * (GetConVar("ttt2_decipherer_start_charge_pct"):GetInt() * 0.01)
SWEP.Primary.Ammo = "none"

SWEP.AllowDrop = false

SWEP.TimeToDecipherRole = 4

if SERVER then
	-- remove on death or drop (no one else should use this)
	function SWEP:OnDrop()
		self:Remove()
	end
	
	function SWEP:Deploy()
		self.NextEffectTime = CurTime() + 1
	end
	
	-- make sure weapon values line up with convars
	function SWEP:Initialize()
		-- add the current values for decitester uses to be networked
		local maxUses = GetConVar("ttt2_decipherer_max_uses"):GetInt()
		self:SetNWInt("decitester_max_uses", maxUses or 0)
		self:SetNWInt("decitester_cur_uses", maxUses or 0)
		
		-- add charge values to get networked
		local maxCharge = GetConVar("ttt2_decipherer_max_charge"):GetInt()
		self:SetNWInt("decitester_max_charge", maxCharge)
		self.Primary.ClipSize = maxCharge
		
		local currentCharge = maxCharge * (GetConVar("ttt2_decipherer_start_charge_pct"):GetInt() * 0.01)
		self:SetNWInt("decitester_current_charge", currentCharge)
		self.Primary.DefaultClip = currentCharge
		return
	end
	
	-- networked variables
	function SWEP:SetState(state)
        self:SetNWInt("decitester_state", state or DECITESTER_IDLE)
    end

    function SWEP:SetStartTime(time)
        self:SetNWFloat("decitester_start_time", time or 0)
    end

    function SWEP:SetScanTime(time)
        self:SetNWFloat("decitester_scan_time", time or 0)
    end

    function SWEP:SubtractMinitesterUse()
		local uses = self:GetNWInt("decitester_cur_uses" or 0)
		uses = uses - 1
        self:SetNWFloat("decitester_cur_uses", uses or 0)
    end
	
	-- easy reset to beginning
	function SWEP:Reset()
		self.decitestTarget = nil
        self:SetState(DECITESTER_IDLE)
    end
	
	-- error handling
	function SWEP:Message(type)
		local owner = self:GetOwner()
		if not IsValid(owner) then return end
		
		self:SetNextPrimaryFire(CurTime() + DECITESTER_FIRE_DELAY)
		
		if type == DECITESTER_ERROR_NOT_PLAYER then
            LANG.Msg(owner, "ttt2_label_decipherer_error_no_player", nil, MSG_MSTACK_WARN)
			self:PlaySound("zap")
		elseif type == DECITESTER_ERROR_LOST_TARGET then
			LANG.Msg(owner, "ttt2_label_decipherer_error_lost_target", nil, MSG_MSTACK_WARN)
			self:PlaySound("zap")
		elseif type == DECITESTER_ERROR_NO_USES then
			LANG.Msg(owner, "ttt2_label_decipherer_error_no_uses", nil, MSG_MSTACK_WARN)
			self:PlaySound("empty")
		elseif type == DECITESTER_ERROR_NOT_CHARGED then
			LANG.Msg(owner, "ttt2_label_decipherer_error_not_charged", nil, MSG_MSTACK_WARN)
			self:PlaySound("empty")
		elseif type == DECITESTER_MSG_READY then
			LANG.Msg(owner, "ttt2_label_decipherer_msg_ready", nil, MSG_MSTACK_ROLE)
			self:PlaySound("ready")
		end
	end
	
	-- fun sounds
	function SWEP:PlaySound(soundName)
		local owner = self:GetOwner()
		if not IsValid(owner) then return end
		owner:EmitSound(sounds[soundName])
	end
	
	function SWEP:StopSound(soundName)
        local owner = self:GetOwner()
		if not IsValid(owner) then return end
        owner:StopSound(sounds[soundName])
    end
	
	-- actual logic
	function SWEP:PrimaryAttack()
		local owner = self:GetOwner()
		if not IsValid(owner) then return end
		
		-- check how many uses are left
		if GetConVar("ttt2_decipherer_max_uses_enabled"):GetBool() and self:GetCurrentUses() <= 0 then
			self:Message(DECITESTER_ERROR_NO_USES)
			return
		end
		
		-- check if charged
		if self:Clip1() < self.Primary.ClipSize then
			self:Message(DECITESTER_ERROR_NOT_CHARGED)
			return
		end
		
		local trace = owner:GetEyeTrace(MASK_SHOT_HULL)
        local distance = trace.StartPos:Distance(trace.HitPos)
        local ent = trace.Entity
		
		if distance > 100 then
			self:Message(DECITESTER_ERROR_NOT_PLAYER)
			return
		end
		
		if not ent:IsPlayer() then
			self:Message(DECITESTER_ERROR_NOT_PLAYER)
			return
		end
		
		-- little server var
        self.decitestTarget = ent
		
		-- start the scan for think function
		self:StartScanningPlayer(ent)
	end
	
	function SWEP:StartScanningPlayer(ply)
		self:SetState(DECITESTER_BUSY)
		self:SetStartTime(CurTime())
        self:SetScanTime(self.TimeToDecipherRole)
        self:PlaySound("hum")
	end
	
	function SWEP:Think()
		local owner = self:GetOwner()
		if not IsValid(owner) then return end
		
		-- no uses left
		if self:GetNWFloat("decitester_cur_uses") <= 0 then return end
		
		-- if we are idle
		if self:GetState() ~= DECITESTER_BUSY then
			-- time gate charge logic
			if (self.NextChargeTime or 0) > CurTime() then return end
			self.NextChargeTime = CurTime() + 0.2
			
			-- if we are fully charged already
			if self:Clip1() >= self.Primary.ClipSize then return end
			
			if (self.NextEffectTime or 0) <= CurTime() then
				self.NextEffectTime = CurTime() + 1
				
				local ed = EffectData()
				ed:SetOrigin(owner:GetPos())
				util.Effect("decitester_charge_pulse", ed, true, true)
			
				self:PlaySound("charge")
			end
			
			-- charge
			self:SetClip1(self:Clip1() + 1)
			if self:Clip1() >= self.Primary.ClipSize then
				self:Message(DECITESTER_MSG_READY)
			end
			return
		end
		
		local target = self.decitestTarget
		if not IsValid(target) then return end
		
		if CurTime() >= self:GetStartTime() + self.TimeToDecipherRole - 0.01 then
			self:ScanSuccess(target)
        elseif not IsValid(owner) or not IsValid(target)
			or not owner:KeyDown(IN_ATTACK)
			or not owner:GetEyeTrace(MASK_SHOT_HULL).Entity:IsPlayer() then
			
			-- time to reset
			self:StopSound("hum")
            self:Reset()
            self:Message(DECITESTER_ERROR_LOST_TARGET)
        end
	end
	
	function SWEP:ScanSuccess(ply)
		local owner = self:GetOwner()
		if not IsValid(owner) then return end
		
		net.Start("TTT2_Decipherer_EPOP")
			net.WriteString("ttt2_label_decipherer_epop")
			net.WriteString(ply:GetRoleString())
			net.WriteColor(ply:GetRoleColor(), false)
			net.WritePlayer(ply)
		net.Send(owner)
		
		self:SetState(DECITESTER_IDLE)
		
		-- subtract use if enabled
		if GetConVar("ttt2_decipherer_max_uses_enabled"):GetBool() then
			self:SubtractMinitesterUse()
		end
		
		self:SetClip1(0)
		
		self.NextEffectTime = CurTime() + 1
		
		events.Trigger("deci_minitester", owner, ply)
		
		-- on traitor effects
		local plyTeam = ply:GetRealTeam()
		if plyTeam ~= TEAM_TRAITOR then
			self:PlaySound("testFine")
			return
		end
		self:PlaySound("testEvil")
		
		-- discombob on traitor
		if GetConVar("ttt2_decipherer_discombob_on_traitor"):GetBool() then
			local dbombClass = "ttt_confgrenade_proj"
			local dbomb = ents.Create(dbombClass)
			if not IsValid(dbomb) then return end
			
			dbomb:SetPos(owner:GetPos())
			dbomb:SetOwner(owner)
			dbomb:SetThrower(owner)
			dbomb:Spawn()
			
			local phys = dbomb:GetPhysicsObject()
			
			if IsValid(phys) then
				phys:Wake()
			end
			
			dbomb:SetDetonateExact(CurTime())
		end
		
		-- smoke on traitor
		if GetConVar("ttt2_decipherer_smoke_on_traitor"):GetBool() then
			local smokeClass = "ttt_smokegrenade_proj"
			local smoke = ents.Create(smokeClass)
			if not IsValid(smoke) then return end
			
			smoke:SetPos(owner:GetPos())
			smoke:SetOwner(owner)
			smoke:SetThrower(owner)
			smoke:Spawn()
			
			local phys = smoke:GetPhysicsObject()
			
			if IsValid(phys) then
				phys:Wake()
			end
			
			smoke:SetDetonateExact(CurTime())
		end
		
		-- destroy on traitor
		if GetConVar("ttt2_decipherer_destroy_on_traitor"):GetBool() then
            self:Remove()
		end
	end
end

-- do not play sound when swep is empty
function SWEP:DryFire()
    return false
end

-- shared network variables so client can only read stuff
function SWEP:GetState()
    return self:GetNWInt("decitester_state", DECITESTER_IDLE)
end

function SWEP:GetCurrentUses()
    return self:GetNWInt("decitester_cur_uses", 0)
end

function SWEP:GetMaxUses()
    return self:GetNWInt("decitester_max_uses", 0)
end

function SWEP:GetStartTime()
    return self:GetNWFloat("decitester_start_time", 0)
end

function SWEP:GetScanTime()
    return self:GetNWFloat("decitester_scan_time", 0)
end

if CLIENT then
    function SWEP:Initialize()
        self:AddTTT2HUDHelp("ttt2_label_decipherer_minitester_help")
        BaseClass.Initialize(self)
    end
	
	function SWEP:PrimaryAttack() end
	
	local colorDetectiveBlue = Color(31, 77, 191, 255)
	hook.Add("TTTRenderEntityInfo", "ttt2_decitester_display_info", function(tData)
        local ent = tData:GetEntity()
        local client = LocalPlayer()
        local activeWeapon = client:GetActiveWeapon()

        -- has to be a player
        if not ent:IsPlayer() then return end

        -- player has to hold a decitester
        if not IsValid(activeWeapon) or activeWeapon:GetClass() ~= "weapon_ttt2_decitester" then return end

        -- ent has to be in usable range
        if tData:GetEntityDistance() > 100 then return end

        tData:AddDescriptionLine(
            LANG.GetParamTranslation(
                "ttt2_label_decipherer_hold_key_to_scan",
                { key = Key("+attack", "LEFT MOUSE") }
            ),
            colorDetectiveBlue
        )
		
		if GetConVar("ttt2_decipherer_max_uses_enabled"):GetBool() then
			tData:AddDescriptionLine(
				LANG.GetParamTranslation("ttt2_label_decipherer_uses_left", {current = activeWeapon:GetCurrentUses(), maximum = activeWeapon:GetMaxUses() }),
				colorDetectiveBlue
			)
		end
		
		if activeWeapon:GetState() ~= DECITESTER_BUSY then return end
		
		-- draw the progress bar
		local progress = math.min((CurTime() - activeWeapon:GetStartTime()) / activeWeapon:GetScanTime(), 1.0)
        local timeLeft = activeWeapon:GetScanTime() - (CurTime() - activeWeapon:GetStartTime())

        local x = 0.5 * ScrW()
        local y = 0.5 * ScrH()
        local w, h = 0.2 * ScrW(), 0.025 * ScrH()
		y = 0.95 * y
		
		surface.SetDrawColor(50, 50, 50, 220)
        surface.DrawRect(x - 0.5 * w, y - h, w, h)
        surface.SetDrawColor(clr(colorDetectiveBlue))
        surface.DrawOutlinedRect(x - 0.5 * w, y - h, w, h)
        surface.SetDrawColor(
            clr(ColorAlpha(colorDetectiveBlue, (0.5 + 0.15 * math.sin(CurTime() * 4)) * 255))
        )
        surface.DrawRect(x - 0.5 * w + 2, y - h + 2, w * progress - 4, h - 4)

        tData:AddDescriptionLine(
            LANG.GetParamTranslation("ttt2_label_decipherer_scan_progress", { time = math.Round(timeLeft, 1) }),
            colorDetectiveBlue
        )
		
		tData:SetOutlineColor(colorDetectiveBlue)
    end)
	
	net.Receive("TTT2_Decipherer_EPOP", function(len, ply)
		local title = net.ReadString()
		local role = net.ReadString()
		local color = net.ReadColor(false)
		local victim = net.ReadPlayer()
		
		local textString = LANG.GetParamTranslation(title, {player = victim:Nick(), role = role})
		
		EPOP:AddMessage({text = textString, color = color}, "ttt2_label_decipherer_epop_desc", displayTime, nil, true)
	end)
end
