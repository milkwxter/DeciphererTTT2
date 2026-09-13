EFFECT.Mat = Material("effects/select_ring")

local colorDecipherer = Color(31, 77, 191, 255)

function EFFECT:Init(data)
	self.Position = data:GetOrigin()
	
	self.StartSize = 32
	self.EndSize = 256
	self.Size = self.StartSize
	
	self.Alpha = 255
	
	self.Life = 0.6
	self.Elapsed = 0
end

function EFFECT:Think()
	self.Elapsed = self.Elapsed + FrameTime()
	
	local frac = math.Clamp(self.Elapsed / self.Life, 0, 1)
	
	self.Size = Lerp(frac, self.StartSize, self.EndSize)
	self.Alpha = Lerp(frac, 255, 0)
	
	if self.Elapsed >= self.Life then return false end
	return true
end

function EFFECT:Render()
	if self.Alpha <= 1 then return end
	
	render.SetMaterial(self.Mat)
	
	local color = colorDecipherer
	color.a = self.Alpha
	
	render.DrawQuadEasy(
		self:GetPos(),
		self:GetAngles():Up(),
		self.Size,
		self.Size,
		color
	)
end