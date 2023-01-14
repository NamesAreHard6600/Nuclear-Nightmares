--Functions and Variables
local path = mod_loader.mods[modApi.currentMod].resourcePath
local mod = mod_loader.mods[modApi.currentMod]
local resourcePath = mod.resourcePath
local scriptPath = mod.scriptPath
local previewer = mod.libs.weaponPreview
local hotkey = require(scriptPath.."libs/hotkey")
local tips = require(scriptPath .."libs/tutorialTips")
local function IsTipImage()
	return Board:GetSize() == Point(6,6)
end


--Nuclear Punch: Prime Weapon
Nuclear_Punch = Skill:new{
	Name = "Nuclear Punch",
	Description = "Pushes an adjacent target and deals damage equal to Energy, then decreases Energy by 1. Starting Energy 3.",
	DamageTip = "Energy",
	Class = "Prime",
	Icon = "weapons/NuclearFistIcon.png",
	Rarity = 3, --Change
	Explosion = "",
	LaunchSound = "/weapons/titan_fist", --Change
	Range = 1, -- Tooltip?
	PathSize = 1,
	--Damage = 3, -- Tooltip (no longer needed with custom)
	--MinDamage = 0, -- Tooltip (no longer needed with custom)
	PushBack = false,
	Flip = false,
	Dash = false,
	Shield = false,
	Projectile = false,
	--Push = 1, --Mostly for tooltip, but you could turn it off for some unknown reason
	PowerCost = 1,
	Upgrades = 1,
	--UpgradeList = { "+1 Starting Power"},
	UpgradeCost = { 2 },
	TipDamageCustom = "Energy",

	--Custom Variables
	MaxPrimePower = 3,
	PrimePower = 3,
	PrimeTestMechPower = 3,
	extra = 0,

	CustomTipImage = "Nuclear_Punch_Tip",
	TipImage = {
		Unit = Point(2,2),
		Enemy = Point(2,1),
		Target = Point(2,1),
	}
}
Nuclear_Punch_A = Nuclear_Punch:new {
	Damage = 4, --For Tooltip
	extra = 1,
	CustomTipImage = "Nuclear_Punch_Tip_A"
}

function Nuclear_Punch:GetTargetArea(point)
	local ret = PointList()
	local counter
	local myid = Pawn:GetId()
	local mission = GetCurrentMission()
	for i = DIR_START, DIR_END do
		local curr = DIR_VECTORS[i] + point
		ret:push_back(curr)
	end

	--previewer
	previewer:SetLooping(true)
	if mission and not IsTipImage() and not IsTestMechScenario() then
		tips:Trigger("Energy",point)
		counter = mission.NAH_NuclearPowerValues[myid].PrimePower
	elseif IsTestMechScenario() and not IsTipImage() then
		counter = self.PrimeTestMechPower
	else
		counter = self.PrimePower
	end
	for y = 1, 10 do
		if y > counter then
			break
		elseif y > counter - 1 then
			previewer:AddAnimation(point, "NAH_flashing_"..y)
		else
			previewer:AddAnimation(point, "NAH_on_"..y)
		end
	end

	return ret
end
function Nuclear_Punch:GetSkillEffect(p1, p2)
	local mission = GetCurrentMission()
	local myid = Pawn:GetId()
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local target = p2
	local damage
	if mission and not IsTipImage() and not IsTestMechScenario() then
		dmg_value = mission.NAH_NuclearPowerValues[myid].PrimePower + self.extra
		damage = SpaceDamage(target, dmg_value, direction)
		ret:AddScript([[
			local myid = ]]..myid..[[
			local mission = GetCurrentMission()
			if mission.NAH_NuclearPowerValues[myid].PrimePower > 0 then
				mission.NAH_NuclearPowerValues[myid].PrimePower = mission.NAH_NuclearPowerValues[myid].PrimePower - 1
			end
		]])
		--[[
		if dmg_value >= 6 then
			ret:AddScript("NAH_NN_Chievo('NAH_NN_a')")
		end
		]]--
	elseif IsTestMechScenario() and not IsTipImage() then
		damage = SpaceDamage(target, self.PrimeTestMechPower + self.extra, direction)
		ret:AddScript([[
			if Nuclear_Punch.PrimeTestMechPower > 0 then
				Nuclear_Punch.PrimeTestMechPower = Nuclear_Punch.PrimeTestMechPower - 1
			end
		]])
	end
	damage.sAnimation = "explopunch1_"..direction
	ret:AddDamage(damage)

	return ret
end

--Tip Image Magic (with lots of copy paste, because that's what seemed to work best)
Nuclear_Punch_Tip = Nuclear_Punch:new{}
Nuclear_Punch_Tip_A = Nuclear_Punch_A:new{}

function Nuclear_Punch_Tip:GetSkillEffect(p1, p2)
	local counter = self.PrimePower
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local damage  = SpaceDamage(p2, self.PrimePower + self.extra, direction)
	damage.sAnimation = "explopunch1_"..direction
	ret:AddDamage(damage)
	for y = 1, 10 do
		if y > counter then
			break
		elseif y > counter - 1 then
			Board:AddAnimation(p1, "NAH_flashing_long_"..y,1)
		else
			Board:AddAnimation(p1, "NAH_on_long_"..y,1)
		end
	end
	if self.PrimePower == 0 then  --For tooltip
		self.PrimePower = self.MaxPrimePower
	else
		self.PrimePower = self.PrimePower - 1
	end
	return ret
end
function Nuclear_Punch_Tip_A:GetSkillEffect(p1, p2)
	local counter = self.PrimePower
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local damage  = SpaceDamage(p2, self.PrimePower + self.extra, direction)
	damage.sAnimation = "explopunch1_"..direction
	ret:AddDamage(damage)
	for y = 1, 10 do
		if y > counter then
			break
		elseif y > counter - 1 then
			Board:AddAnimation(p1, "NAH_flashing_long_"..y,1)
		else
			Board:AddAnimation(p1, "NAH_on_long_"..y,1)
		end
	end
	if self.PrimePower == 0 then  --For tooltip
		self.PrimePower = self.MaxPrimePower
	else
		self.PrimePower = self.PrimePower - 1
	end
	return ret
end


--Nuclear Beam: Brute Weapon
Nuclear_Beam = Skill:new{
	Name = "Nuclear Beam",
	Description = "Pushes and damages targets in a line. Covers a chosen number of tiles, up to Energy, then decreases Energy by that amount. Starting Energy 6.",
	Class = "Brute",
	Icon = "weapons/NuclearBeamIcon.png",
	LaserArt = "effects/laser_push",
	Rarity = 3, --Change
	Explosion = "",
	LaunchSound = "/weapons/push_beam",
	Damage = 1,
	PathSize = 10,
	PushBack = false,
	Flip = false,
	Dash = false,
	Shield = false,
	Projectile = false,
	Push = 1, --Mostly for tooltip, but you could turn it off for some unknown reason
	PowerCost = 1,
	Upgrades = 2,
	--UpgradeList = {-1 Power Used, +1 Damage},
	UpgradeCost = {2, 3},

	--Custom Variables
	MaxBrutePower = 6,
	BrutePower = 6, --For Tooltip
	BruteTestMechPower = 6,
	LaserArt = "effects/laser_push",
	MinusPower = 0,

	CustomTipImage = "Nuclear_Beam_Tip",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,2),
		Enemy2 = Point(2,1),
		Target = Point(2,1),
		Enemy3 = Point(2,0),
		CustomEnemy = "Firefly2", --"Scorpion2",
	}
}
Nuclear_Beam_A = Nuclear_Beam:new {
	MinusPower = 1,
	CustomTipImage = "Nuclear_Beam_Tip_A",
}
Nuclear_Beam_B = Nuclear_Beam:new {
	Damage = 2,
	CustomTipImage = "Nuclear_Beam_Tip_B",
}
Nuclear_Beam_AB = Nuclear_Beam:new {
	MinusPower = 1,
	Damage = 2,
	CustomTipImage = "Nuclear_Beam_Tip_AB",
}

function Nuclear_Beam:GetTargetArea(point)
	local ret = PointList()
	local mission = GetCurrentMission()
	if mission and not IsTipImage() then
		tips:Trigger("Energy",point)
		local myid = Pawn:GetId()
		local range
		if not IsTestMechScenario() then
			range = mission.NAH_NuclearPowerValues[myid].BrutePower --Odd problem here I don't know what's causing it ./mods/My_Mod/scripts/weapons.lua:172: attempt to index field '?' (a nil value) It's been gone for a while, we'll see if it comes back or not; it came back once in someone elses run.
		else
			range = self.BruteTestMechPower
		end

		for i = DIR_START, DIR_END do
			for k = 1, range do
				local curr = DIR_VECTORS[i]*k + point
				if Board:GetTerrain(curr) ~= TERRAIN_MOUNTAIN and Board:IsValid(curr) then
				--if Board:IsValid(curr) and not Board:IsBlocked(curr, Pawn:GetPathProf()) then
					ret:push_back(DIR_VECTORS[i]*k + point)
				else
					break
				end
			end
		end
	else
		for i = DIR_START, DIR_END do
			for k = 1, 8 do
				local curr = DIR_VECTORS[i]*k + point
				if Board:GetTerrain(curr) ~= TERRAIN_MOUNTAIN and Board:IsValid(curr) then
				--if Board:IsValid(curr) and not Board:IsBlocked(curr, Pawn:GetPathProf()) then
					ret:push_back(DIR_VECTORS[i]*k + point)
				else
					break
				end
			end
		end
	end
	return ret


end
function Nuclear_Beam:GetSkillEffect(p1, p2)
	local mission = GetCurrentMission()
	local damage
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
	local myid = Pawn:GetId()
	local targets = {}
	local curr = p1 + DIR_VECTORS[dir]
	while Board:GetTerrain(curr) ~= TERRAIN_MOUNTAIN and Board:IsValid(curr) and curr ~= p2 do
		targets[#targets+1] = curr
		curr = curr + DIR_VECTORS[dir]
	end
	if Board:GetTerrain(curr) ~= TERRAIN_MOUNTAIN and Board:IsValid(curr) then
		targets[#targets+1] = curr
	end

	damage = SpaceDamage(curr, 0)
	ret:AddDamage(damage)
	ret:AddProjectile(damage,self.LaserArt)


	if mission and not IsTipImage() then
		local total = 0
		for i = 1, #targets do
			local curr = targets[#targets - i + 1]
			total = total + 1
			if Board:IsPawnSpace(curr) then
				ret:AddDelay(0.1)
			end
			if not IsTestMechScenario() then
				ret:AddScript([[
					local myid = ]]..myid..[[
					local mission = GetCurrentMission()
					if mission.NAH_NuclearPowerValues[myid].BrutePower > 0 then
						mission.NAH_NuclearPowerValues[myid].BrutePower = mission.NAH_NuclearPowerValues[myid].BrutePower - 1
					end
				]])
			else
				ret:AddScript([[
					if Nuclear_Beam.BruteTestMechPower > 0 then
						Nuclear_Beam.BruteTestMechPower = Nuclear_Beam.BruteTestMechPower - 1
					end
				]])
			end
			damage = SpaceDamage(curr, self.Damage, dir)
			ret:AddDamage(damage)
			previewer:SetLooping(true)

			if IsTestMechScenario() then
				counter = Nuclear_Beam.BruteTestMechPower
			else
				counter = mission.NAH_NuclearPowerValues[myid].BrutePower
			end

			for y = 1, 10 do
				if y > counter then
					break
				elseif y > counter - total + self.MinusPower then
					previewer:AddAnimation(p1, "NAH_flashing_"..y)
				else
					previewer:AddAnimation(p1, "NAH_on_"..y)
				end
			end
		end
		if not IsTestMechScenario() then
			ret:AddScript([[
				local myid = ]]..myid..[[
				local ScriptMinusPower = ]]..tostring(self.MinusPower)..[[
				local mission = GetCurrentMission()
				mission.NAH_NuclearPowerValues[myid].BrutePower = mission.NAH_NuclearPowerValues[myid].BrutePower + tonumber(ScriptMinusPower)
			]])
		else
			ret:AddScript([[
				local ScriptMinusPower = ]]..tostring(self.MinusPower)..[[
				Nuclear_Beam.BruteTestMechPower = Nuclear_Beam.BruteTestMechPower + tonumber(ScriptMinusPower)
			]])
		end

	else
		for i = 1, #targets do
			local curr = targets[#targets - i + 1]
			if Board:IsPawnSpace(curr) then
				ret:AddDelay(0.1)
			end
			damage = SpaceDamage(curr, self.Damage, dir)
			ret:AddDamage(damage)
		end
		if self.BrutePower <= 2 then  --For tooltip
			self.BrutePower = self.MaxBrutePower
		else
			self.BrutePower = self.BrutePower - 2 + self.MinusPower
		end
	end

	return ret
end

--A LOT of Copy and Paste, because that's just what works without erroring because of some inconsistencies with how self works, and when I try to refrence certain parts of things it just makes it have to be more precise
--However, because it's a controlled enviornment, I can hard code in numbers instead of using self, which is what I have done.
--I would suggest closing all these functions if you're not doing anything with them, it's a lot of lines.

Nuclear_Beam_Tip = Nuclear_Beam:new{}
Nuclear_Beam_Tip_A = Nuclear_Beam:new{}
Nuclear_Beam_Tip_B = Nuclear_Beam:new{}
Nuclear_Beam_Tip_AB = Nuclear_Beam:new{}

function Nuclear_Beam_Tip:GetSkillEffect(p1, p2)
	local mission = GetCurrentMission()
	local damage
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
	local myid = Pawn:GetId()
	local targets = {}
	local curr = p1 + DIR_VECTORS[dir]
	while Board:GetTerrain(curr) ~= TERRAIN_MOUNTAIN and Board:IsValid(curr) and curr ~= p2 do
		targets[#targets+1] = curr
		curr = curr + DIR_VECTORS[dir]
	end
	if Board:GetTerrain(curr) ~= TERRAIN_MOUNTAIN and Board:IsValid(curr) then
		targets[#targets+1] = curr
	end


	damage = SpaceDamage(curr, 0)
	ret:AddDamage(damage)
	ret:AddProjectile(damage,self.LaserArt)

	for i = 1, #targets do
		local curr = targets[#targets - i + 1]
		if Board:IsPawnSpace(curr) then
			ret:AddDelay(0.1)
		end
		damage = SpaceDamage(curr, 1, dir)
		ret:AddDamage(damage)
	end

	local counter = self.BrutePower

	for y = 1, 10 do
		if y > counter then
			break
		elseif y > counter - 2 + self.MinusPower then
			Board:AddAnimation(p1, "NAH_flashing_long_"..y,1)
		else
			Board:AddAnimation(p1, "NAH_on_long_"..y,1)
		end
	end

	if self.BrutePower <= 2 then  --For tooltip
		self.BrutePower = self.MaxBrutePower
	else
		self.BrutePower = self.BrutePower - 2 + self.MinusPower
	end

	return ret
end
function Nuclear_Beam_Tip_A:GetSkillEffect(p1, p2)
	local mission = GetCurrentMission()
	local damage
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
	local myid = Pawn:GetId()
	local targets = {}
	local curr = p1 + DIR_VECTORS[dir]
	while Board:GetTerrain(curr) ~= TERRAIN_MOUNTAIN and Board:IsValid(curr) and curr ~= p2 do
		targets[#targets+1] = curr
		curr = curr + DIR_VECTORS[dir]
	end
	if Board:GetTerrain(curr) ~= TERRAIN_MOUNTAIN and Board:IsValid(curr) then
		targets[#targets+1] = curr
	end


	damage = SpaceDamage(curr, 0)
	ret:AddDamage(damage)
	ret:AddProjectile(damage,self.LaserArt)

	for i = 1, #targets do
		local curr = targets[#targets - i + 1]
		if Board:IsPawnSpace(curr) then
			ret:AddDelay(0.1)
		end
		damage = SpaceDamage(curr, 1, dir)
		ret:AddDamage(damage)
	end

	local counter = self.BrutePower

	for y = 1, 10 do
		if y > counter then
			break
		elseif y > counter - 1 + self.MinusPower then
			Board:AddAnimation(p1, "NAH_flashing_long_"..y,1)
		else
			Board:AddAnimation(p1, "NAH_on_long_"..y,1)
		end
	end

	if self.BrutePower <= 2 then  --For tooltip
		self.BrutePower = self.MaxBrutePower
	else
		self.BrutePower = self.BrutePower - 2 + self.MinusPower
	end

	return ret
end
function Nuclear_Beam_Tip_B:GetSkillEffect(p1, p2)
	local mission = GetCurrentMission()
	local damage
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
	local myid = Pawn:GetId()
	local targets = {}
	local curr = p1 + DIR_VECTORS[dir]
	while Board:GetTerrain(curr) ~= TERRAIN_MOUNTAIN and Board:IsValid(curr) and curr ~= p2 do
		targets[#targets+1] = curr
		curr = curr + DIR_VECTORS[dir]
	end
	if Board:GetTerrain(curr) ~= TERRAIN_MOUNTAIN and Board:IsValid(curr) then
		targets[#targets+1] = curr
	end


	damage = SpaceDamage(curr, 0)
	ret:AddDamage(damage)
	ret:AddProjectile(damage,self.LaserArt)

	for i = 1, #targets do
		local curr = targets[#targets - i + 1]
		if Board:IsPawnSpace(curr) then
			ret:AddDelay(0.1)
		end
		damage = SpaceDamage(curr, 2, dir)
		ret:AddDamage(damage)
	end

	local counter = self.BrutePower

	for y = 1, 10 do
		if y > counter then
			break
		elseif y > counter - 2 + self.MinusPower then
			Board:AddAnimation(p1, "NAH_flashing_long_"..y,1)
		else
			Board:AddAnimation(p1, "NAH_on_long_"..y,1)
		end
	end

	if self.BrutePower <= 2 then  --For tooltip
		self.BrutePower = self.MaxBrutePower
	else
		self.BrutePower = self.BrutePower - 1
	end

	return ret
end
function Nuclear_Beam_Tip_AB:GetSkillEffect(p1, p2)
	local mission = GetCurrentMission()
	local damage
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
	local myid = Pawn:GetId()
	local targets = {}
	local curr = p1 + DIR_VECTORS[dir]
	while Board:GetTerrain(curr) ~= TERRAIN_MOUNTAIN and Board:IsValid(curr) and curr ~= p2 do
		targets[#targets+1] = curr
		curr = curr + DIR_VECTORS[dir]
	end
	if Board:GetTerrain(curr) ~= TERRAIN_MOUNTAIN and Board:IsValid(curr) then
		targets[#targets+1] = curr
	end


	damage = SpaceDamage(curr, 0)
	ret:AddDamage(damage)
	ret:AddProjectile(damage,self.LaserArt)

	for i = 1, #targets do
		local curr = targets[#targets - i + 1]
		if Board:IsPawnSpace(curr) then
			ret:AddDelay(0.1)
		end
		damage = SpaceDamage(curr, 2, dir)
		ret:AddDamage(damage)
	end

	local counter = self.BrutePower

	for y = 1, 10 do
		if y > counter then
			break
		elseif y > counter - 1 then
			Board:AddAnimation(p1, "NAH_flashing_long_"..y,1)
		else
			Board:AddAnimation(p1, "NAH_on_long_"..y,1)
		end
	end

	if self.BrutePower <= 2 then  --For tooltip
		self.BrutePower = self.MaxBrutePower
	else
		self.BrutePower = self.BrutePower - 1
	end

	return ret
end


--Materialize Box: Science Primary Weapon   TO DO: make flipy box land better
Materialize_Box = Skill:new {
	Name = "Materialize Box",
	Description = "Deploy a 1 health box within a range equal to your Energy, then decreases Energy by 1. The box has the ability to combust, dealing itself one self damage, pushing adjacent units. Starting Energy 3.",
	Icon = "weapons/BoxDropIcon.png",
	Class = "Science",
	Rarity = 3,
	Deployed = "NAH_NuclearBox",
	Projectile = "effects/nuclear_box.png", --"effects/box.png" Old
	PowerCost = 0,
	Upgrades = 2,
	UpgradeCost = {1,2},
	--UpgradeList {Super Charged, +1 Health}
	LaunchSound = "/weapons/deploy_tank",
	ImpactSound = "/impact/generic/mech",

	--Custom Variables
	SciencePower = 3,
	MaxSciencePower = 3,
	ScienceTestMechPower = 3,

	CustomTipImage = "Materialize_Box_Tip",

	TipImage = {
		Unit = Point(2,3),
		Target = Point(3,2),
		Enemy = Point (2,2),
		Second_Origin = Point(3,2),
		Second_Target = Point(3,2),
	}
}
Materialize_Box_A = Materialize_Box:new {
	Deployed = "NAH_NuclearBoxA",
	CustomTipImage = "Materialize_Box_Tip_A",
}
Materialize_Box_B = Materialize_Box:new {
	Deployed = "NAH_NuclearBoxB",
	CustomTipImage = "Materialize_Box_Tip_B",
}
Materialize_Box_AB = Materialize_Box:new {
	Deployed = "NAH_NuclearBoxAB",
	CustomTipImage = "Materialize_Box_Tip_AB",
}

function Materialize_Box:GetTargetArea(point)
	local ret = PointList()
	local mission = GetCurrentMission()
	local myid = Pawn:GetId()
	local center = point

	local size
	if mission and not IsTipImage() and not IsTestMechScenario() then
		tips:Trigger("Energy",point)
		size = mission.NAH_NuclearPowerValues[myid].SciencePower
	elseif IsTestMechScenario() and not IsTipImage() then
		size = self.ScienceTestMechPower
	else
		size = self.SciencePower
	end
	--Copied and slightly altered from "function general_DiamondTarget" in weapons_base.lua
	local corner = center - Point(size, size)

	local p = Point(corner)

	for i = 0, ((size*2+1)*(size*2+1)) do
		local diff = center - p
		local dist = math.abs(diff.x) + math.abs(diff.y)
		if Board:IsValid(p) and dist <= size and not Board:IsBlocked(p,PATH_GROUND) then
			ret:push_back(p)
		end
		p = p + VEC_RIGHT
		if math.abs(p.x - corner.x) == (size*2+1) then
			p.x = p.x - (size*2+1)
			p = p + VEC_DOWN
		end
	end

	for y = 1, 10 do
		if y > size then
			break
		elseif y > size - 1 then
			previewer:AddAnimation(point, "NAH_flashing_"..y)
		else
			previewer:AddAnimation(point, "NAH_on_"..y)
		end
	end

	return ret
end
function Materialize_Box:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local mission = GetCurrentMission()
	local myid = Pawn:GetId()
	local damage
	if mission and not IsTipImage() and not IsTestMechScenario() then
		ret:AddScript([[
			local myid = ]]..myid..[[
			local mission = GetCurrentMission()
			mission.NAH_NuclearPowerValues[myid].SciencePower = mission.NAH_NuclearPowerValues[myid].SciencePower - 1
		]])
	elseif IsTestMechScenario() and not IsTipImage() then
		ret:AddScript([[
			local myid = ]]..myid..[[
			local mission = GetCurrentMission()
			Materialize_Box.ScienceTestMechPower = Materialize_Box.ScienceTestMechPower - 1
		]])
	end
	damage = SpaceDamage(p2, 0)
	damage.sPawn = self.Deployed
	ret:AddDamage(damage)
	ret:AddTeleport(p2,Point(-1,-1),NO_DELAY) --Play Teleport Animation

	return ret
end

--A LOT of Copy and Paste, because that's just what works without erroring because of some inconsistencies with how self works, and when I try to refrence certain parts of things it just makes it have to be more precise
--However, because it's a controlled enviornment, I can hard code in numbers instead of using self, which is what I have done.
--I would suggest closing all these functions if you're not doing anything with them, it's a lot of lines.

Materialize_Box_Tip = Materialize_Box:new{}
Materialize_Box_Tip_A = Materialize_Box_A:new{}
Materialize_Box_Tip_B = Materialize_Box_B:new{}
Materialize_Box_Tip_AB = Materialize_Box_AB:new{}

function Materialize_Box_Tip:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local mission = GetCurrentMission()
	local myid = Pawn:GetId()
	local counter = self.SciencePower
	local damage
	if self.SciencePower == 3 then
		self.SciencePower = self.SciencePower - 1
	else
		self.SciencePower = 3
	end
	damage = SpaceDamage(p2, 0)
	damage.sPawn =  "NAH_NuclearBox"
	ret:AddDamage(damage)
	ret:AddTeleport(p2,Point(-1,-1),NO_DELAY) --Play Teleport Animation

	for y = 1, 10 do
		if y > counter then
			break
		elseif y > counter - 1 then
			Board:AddAnimation(p1, "NAH_flashing_long_"..y,1)
		else
			Board:AddAnimation(p1, "NAH_on_long_"..y,1)
		end
	end
	return ret
end
function Materialize_Box_Tip_A:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local mission = GetCurrentMission()
	local myid = Pawn:GetId()
	local counter = self.SciencePower
	local damage
	if self.SciencePower == 3 then
		self.SciencePower = self.SciencePower - 1
	else
		self.SciencePower = 3
	end
	damage = SpaceDamage(p2, 0)
	damage.sPawn =  "NAH_NuclearBoxA"
	ret:AddDamage(damage)
	ret:AddTeleport(p2,Point(-1,-1),NO_DELAY) --Play Teleport Animation

	for y = 1, 10 do
		if y > counter then
			break
		elseif y > counter - 1 then
			Board:AddAnimation(p1, "NAH_flashing_long_"..y,1)
		else
			Board:AddAnimation(p1, "NAH_on_long_"..y,1)
		end
	end
	return ret
end
function Materialize_Box_Tip_B:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local mission = GetCurrentMission()
	local myid = Pawn:GetId()
	local counter = self.SciencePower
	local damage
	if self.SciencePower == 3 then
		self.SciencePower = self.SciencePower - 1
	else
		self.SciencePower = 3
	end
	damage = SpaceDamage(p2, 0)
	damage.sPawn =  "NAH_NuclearBoxB"
	ret:AddDamage(damage)
	ret:AddTeleport(p2,Point(-1,-1),NO_DELAY) --Play Teleport Animation

	for y = 1, 10 do
		if y > counter then
			break
		elseif y > counter - 1 then
			Board:AddAnimation(p1, "NAH_flashing_long_"..y,1)
		else
			Board:AddAnimation(p1, "NAH_on_long_"..y,1)
		end
	end
	return ret
end
function Materialize_Box_Tip_AB:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local mission = GetCurrentMission()
	local myid = Pawn:GetId()
	local counter = self.SciencePower
	local damage
	if self.SciencePower == 3 then
		self.SciencePower = self.SciencePower - 1
	else
		self.SciencePower = 3
	end
	damage = SpaceDamage(p2, 0)
	damage.sPawn =  "NAH_NuclearBoxAB"
	ret:AddArtillery(damage,"effects/nuclear_box.png")

	for y = 1, 10 do
		if y > counter then
			break
		elseif y > counter - 1 then
			Board:AddAnimation(p1, "NAH_flashing_long_"..y,1)
		else
			Board:AddAnimation(p1, "NAH_on_long_"..y,1)
		end
	end
	return ret
end

--Fission Generator: Science Secondary Weapon
Fission_Generator = Skill:new {
	Name = "Fission Generator",
	Description = "Restores the Energy of all weapons in one mech to their Starting Energy.",
	Class = "Science",
	Icon = "weapons/FissionGeneratorIcon.png",
	Rarity = 3, --Change
	LaunchSound = "/weapons/science_repulse",
	PowerCost = 0,
	Upgrades = 2,
	--UpgradeList = { "+1 Power Gain", Reactivate},
	UpgradeCost = {1, 2},
	Damage = 0,
	Limited = 1,

	--Custom Variables
	Extra = 0,
	Reactivate = false,

	CustomTipImage = "Fission_Generator_Tip",

	TipImage = {
		Unit = Point(2,2),
		Target = Point(2,2),
	}
	--[[
		Target = Point(2,2),
		Enemy = Point(2,1),
		CustomPawn = "NuclearMech",
		Enemy2 = Point(1,1),
		CustomPawn = "RechargeMech",
		Unit = Point(1,3),
		SecondOrgin = Point(1,1),
		SecondTarget = Point(2,1),

		Unit = Point(2,2),
		Target = Point(2,2),
	--]]

}
Fission_Generator_A = Fission_Generator:new {
	CustomTipImage = "Fission_Generator_Tip_A",
	Extra = 2,
}
Fission_Generator_B = Fission_Generator:new {
	CustomTipImage = "Fission_Generator_Tip_B",
	Reactivate = true,
	TipImage = {
		Unit = Point(2,2),
		Target = Point(2,2),
		Second_Target = Point(3,2),
		Second_Orgin = Point(2,2),
	}
}
Fission_Generator_AB = Fission_Generator:new {
	CustomTipImage = "Fission_Generator_Tip_AB",
	Extra = 2,
	Reactivate = true,
	TipImage = {
		Unit = Point(2,2),
		Target = Point(2,2),
		Second_Target = Point(3,2),
		Second_Orgin = Point(2,2),
	}
}

function Fission_Generator:GetTargetArea(point)
	local ret = PointList()
	local mission = GetCurrentMission()
	local board_size = Board:GetSize()
	if mission and not IsTipImage() and not IsTestMechScenario() then
		tips:Trigger("GainEnergy",point)
	end
	for i = 0, board_size.x - 1 do
		for j = 0, board_size.y - 1  do
			if mission then
				if Board:IsPawnTeam(Point(i,j),TEAM_PLAYER) and Board:GetPawn(Point(i,j)):GetId() >= 0 and Board:GetPawn(Point(i,j)):GetId() <= 2 then
					local pawn_id = Board:GetPawn(Point(i,j)):GetId()
					ret:push_back(Point(i,j))
				end
			elseif Board:IsPawnTeam(Point(i,j),TEAM_PLAYER) then
				local pawn_id = Board:GetPawn(Point(i,j)):GetId()
				ret:push_back(Point(i,j))
			end
		end
	end

	return ret
end
function Fission_Generator:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local Offset
	local mission = GetCurrentMission()
	local SpaceId = Board:GetPawn(p2):GetId()
	local SpaceName = Board:GetPawn(p2):GetMechName()
	previewer:SetLooping(true)
	if mission and not IsTipImage() and not IsTestMechScenario() then
		ret:AddScript([[
			local mission = GetCurrentMission()
			local SpaceId = ]]..tostring(SpaceId)..[[
			local Extra = ]]..tostring(self.Extra)..[[
			local p2 = Point(]]..p2:GetString()..[[)
			mission.NAH_NuclearPowerValues[tonumber(SpaceId)] = {
				PrimePower = Nuclear_Punch.MaxPrimePower + tonumber(Extra),
				BrutePower = Nuclear_Beam.MaxBrutePower + tonumber(Extra),
				SciencePower = Materialize_Box.MaxSciencePower + tonumber(Extra),
			}
		]])

		if SpaceName == "Nuclear Mech" then
			Offset = Nuclear_Punch.MaxPrimePower - mission.NAH_NuclearPowerValues[SpaceId].PrimePower
			Offset = Offset + self.Extra
			for y = 1, 10 do
				if y <= mission.NAH_NuclearPowerValues[SpaceId].PrimePower then
					previewer:AddAnimation(p2, "NAH_on_"..y)
				elseif y <= mission.NAH_NuclearPowerValues[SpaceId].PrimePower + Offset then
					previewer:AddAnimation(p2, "NAH_plus_"..y)
				end
			end
		elseif SpaceName == "Overload Mech" then
			Offset = Nuclear_Beam.MaxBrutePower - mission.NAH_NuclearPowerValues[SpaceId].BrutePower
			Offset = Offset + self.Extra
			for y = 1, 10 do
				if y <= mission.NAH_NuclearPowerValues[SpaceId].BrutePower then
					previewer:AddAnimation(p2, "NAH_on_"..y)
				elseif y <= mission.NAH_NuclearPowerValues[SpaceId].BrutePower + Offset then
					previewer:AddAnimation(p2, "NAH_plus_"..y)
				end
			end
		elseif SpaceName == "Recharge Mech" then
			Offset = Materialize_Box.MaxSciencePower - mission.NAH_NuclearPowerValues[SpaceId].SciencePower
			Offset = Offset + self.Extra
			for y = 1, 10 do
				if y <= mission.NAH_NuclearPowerValues[SpaceId].SciencePower then
					previewer:AddAnimation(p2, "NAH_on_"..y)
				elseif y <= mission.NAH_NuclearPowerValues[SpaceId].SciencePower + Offset then
					previewer:AddAnimation(p2, "NAH_plus_"..y)
				end
			end
		else
			damage = SpaceDamage(p2,0)
			damage.sImageMark = "power/nuclearIcon.png"
			ret:AddDamage(damage)
		end
		--LOG(Offset)
		if Offset >= 8 then
			ret:AddScript("NAH_NN_Chievo('NAH_NN_recharge')")
		end
	elseif not IsTipImage() and IsTestMechScenario() then
		ret:AddScript([[
			local Extra = ]]..tostring(self.Extra)..[[
			Nuclear_Punch.PrimeTestMechPower = Nuclear_Punch.MaxPrimePower + tonumber(Extra)
			Nuclear_Beam.BruteTestMechPower = Nuclear_Beam.MaxBrutePower + tonumber(Extra)
			Materialize_Box.ScienceTestMechPower = Materialize_Box.MaxSciencePower + tonumber(Extra)
		]])
		Offset = 3 - Materialize_Box.ScienceTestMechPower
		Offset = Offset + self.Extra
		for y = 1, 10 do
			if y <= Materialize_Box.ScienceTestMechPower then
				previewer:AddAnimation(p2, "NAH_on_"..y)
			elseif y <= Materialize_Box.ScienceTestMechPower + Offset then
				previewer:AddAnimation(p2, "NAH_plus_"..y)
			end
		end
	end
	ret:AddScript([[
		local p2 = Point(]]..p2:GetString()..[[)
		Game:TriggerSound("/ui/map/flyin_rewards")
		Board:Ping(p2, GL_Color(255, 224, 25))
	]])
	if self.Reactivate then
		ret:AddDelay(.5)
		ret:AddScript([[
			local self = Point(]].. p1:GetString() .. [[)
			Board:GetPawn(self):SetActive(true)
			Board:Ping(self, GL_Color(255, 255, 255));
		]])
	end

	return ret
end

Fission_Generator_Tip = Fission_Generator:new{}
Fission_Generator_Tip_A = Fission_Generator_A:new{}
Fission_Generator_Tip_B = Fission_Generator_B:new{}
Fission_Generator_Tip_AB = Fission_Generator_AB:new{}

function Fission_Generator_Tip:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local offset = 2
	local counter = 1
	for y = 1, 10 do
		if y <= counter then
			Board:AddAnimation(p2, "NAH_on_long_"..y,1)
		elseif y <= counter + offset then
			Board:AddAnimation(p2, "NAH_plus_long_"..y,1)
		end
	end
	ret:AddScript([[
		local p2 = Point(]]..p2:GetString()..[[)
		Game:TriggerSound("/ui/map/flyin_rewards")
		Board:Ping(p2, GL_Color(255, 224, 25))  --Ping works in the hanger? No
	]])

	return ret
end
function Fission_Generator_Tip_A:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local offset = 4
	local counter = 1
	for y = 1, 10 do
		if y <= counter then
			Board:AddAnimation(p2, "NAH_on_long_"..y,1)
		elseif y <= counter + offset then
			Board:AddAnimation(p2, "NAH_plus_long_"..y,1)
		end
	end
	ret:AddScript([[
		local p2 = Point(]]..p2:GetString()..[[)
		Game:TriggerSound("/ui/map/flyin_rewards")
		Board:Ping(p2, GL_Color(255, 224, 25))  --Ping works in the hanger? No
	]])

	return ret
end
function Fission_Generator_Tip_B:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local offset = 2
	local counter = 1
	for y = 1, 10 do
		if y <= counter then
			Board:AddAnimation(p2, "NAH_on_long_"..y,1)
		elseif y <= counter + offset then
			Board:AddAnimation(p2, "NAH_plus_long_"..y,1)
		end
	end
	ret:AddScript([[
		local p2 = Point(]]..p2:GetString()..[[)
		Game:TriggerSound("/ui/map/flyin_rewards")
		Board:Ping(p2, GL_Color(255, 224, 25))  --Ping works in the hanger? No
	]])
	ret:AddDelay(1)
	ret:AddScript([[
		local self = Point(]].. p1:GetString() .. [[)
		Board:Ping(self, GL_Color(255, 255, 255));
	]])

	return ret
end
function Fission_Generator_Tip_AB:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local offset = 4
	local counter = 1
	for y = 1, 10 do
		if y <= counter then
			Board:AddAnimation(p2, "NAH_on_long_"..y,1)
		elseif y <= counter + offset then
			Board:AddAnimation(p2, "NAH_plus_long_"..y,1)
		end
	end
	ret:AddScript([[
		local p2 = Point(]]..p2:GetString()..[[)
		Game:TriggerSound("/ui/map/flyin_rewards")
		Board:Ping(p2, GL_Color(255, 224, 25))
	]])
	ret:AddDelay(1)
	ret:AddScript([[
		local self = Point(]].. p1:GetString() .. [[)
		Board:Ping(self, GL_Color(255, 255, 255));
	]])

	return ret
end

--Combustion: Box Weapon
Combustion = Skill:new {
	Class = "Unique",
	Explosion = "explo_fire1",
	Icon = "weapons/CombustionIcon.png",
	LaunchSound = "/props/exploding_mine", --"/weapons/science_repulse",
	PowerCost = 0,
	--Upgrades = 1,
	--UpgradeList = { "+1 Power Gain", +1 Use},
	--UpgradeCost = {1},
	SelfDamage = 1,

	SuperCharged = false,

	TipImage = {
		Unit = Point(2,2),
		Target = Point(2,2),
		Enemy = Point(2,3),
		Enemy = Point(3,2),
	}
}

Combustion2 = Combustion:new {
	Class = "Unique",
	Explosion = "explo_fire1",
	Icon = "weapons/CombustionIcon.png",
	LaunchSound = "/props/exploding_mine", --"/weapons/science_repulse",
	PowerCost = 0,
	--Upgrades = 1,
	--UpgradeList = { "+1 Power Gain", +1 Use},
	--UpgradeCost = {1},
	SelfDamage = 1,

	SuperCharged = true,

	TipImage = {
		Unit = Point(2,2),
		Target = Point(2,2),
		Enemy = Point(2,3),
		Enemy = Point(3,2),
	}
}

function Combustion:GetTargetArea(point)
	local ret = PointList()
	ret:push_back(point)
	for i = DIR_START, DIR_END do
		ret:push_back(point + DIR_VECTORS[i])
	end
	return ret
end
function Combustion:GetSkillEffect(p1,p2)
	local ret = SkillEffect()

	ret:AddBounce(p1,-2)
	for i = DIR_START,DIR_END do
		local curr = p1 + DIR_VECTORS[i]
		local spaceDamage = SpaceDamage(curr, 0, i)

		if self.ShieldFriendly and (Board:IsBuilding(curr) or Board:GetPawnTeam(curr) == TEAM_PLAYER) then
			spaceDamage.iShield = 1
		end

		spaceDamage.sAnimation = "airpush_"..i
		ret:AddDamage(spaceDamage)

		ret:AddBounce(curr,-1)
	end

	if self.SuperCharged then
		for i = DIR_START, DIR_END do
			curr = p1
			while Board:IsValid(curr) do
				curr = curr + DIR_VECTORS[i]
				previewer:AddColor(curr, GL_Color(255, 224, 25))
				ret:AddScript([[
					local mission = GetCurrentMission()
					if mission and Board:IsPawnTeam(Point(i,j),TEAM_PLAYER) then
						local mechid = Board:GetPawn(Point(i,j)):GetId()
						if mechid >= 0 and mechid <= 2 then
							mission.NAH_NuclearPowerValues[mechid].PrimePower = mission.NAH_NuclearPowerValues[mechid].PrimePower + 1
							mission.NAH_NuclearPowerValues[mechid].BrutePower = mission.NAH_NuclearPowerValues[mechid].BrutePower + 1
							mission.NAH_NuclearPowerValues[mechid].SciencePower = mission.NAH_NuclearPowerValues[mechid].SciencePower + 1
							Board:Ping(p2, GL_Color(255, 224, 25))
						end
						if IsTestMechScenario() then
							Materialize_Box.ScienceTestMechPower = Materialize_Box.ScienceTestMechPower + 1
						end
				]])
			end
		end
	end

	local selfDamage = SpaceDamage(p1, self.SelfDamage)

	--selfDamage.sAnimation = "exploout0_0",--"ExploRepulse1" --Change Animation
	ret:AddDamage(selfDamage)

	return ret
end

function Combustion2:GetTargetArea(point)
	local ret = PointList()
	ret:push_back(point)
	for i = DIR_START, DIR_END do
		ret:push_back(point + DIR_VECTORS[i])
	end
	return ret
end
function Combustion2:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local mission = GetCurrentMission()

	ret:AddBounce(p1,-2)
	for i = DIR_START,DIR_END do
		local curr = p1 + DIR_VECTORS[i]
		local spaceDamage = SpaceDamage(curr, 0, i)

		if self.ShieldFriendly and (Board:IsBuilding(curr) or Board:GetPawnTeam(curr) == TEAM_PLAYER) then
			spaceDamage.iShield = 1
		end

		spaceDamage.sAnimation = "airpush_"..i
		ret:AddDamage(spaceDamage)

		ret:AddBounce(curr,-1)
	end

	if self.SuperCharged then
		for i = DIR_START, DIR_END do
			curr = p1
			while Board:IsValid(curr) do
				curr = curr + DIR_VECTORS[i]
				previewer:AddColor(curr, GL_Color(255, 224, 25))
				previewer:SetLooping(true)
				if mission and Board:IsPawnTeam(curr,TEAM_PLAYER) then
					local mechid = Board:GetPawn(curr):GetId()
					local mechname = Board:GetPawn(curr):GetMechName()
					local counter = false
					if not IsTestMechScenario() and mechid >= 0 and mechid <= 2 then
						if mechname == "Nuclear Mech" then
							counter = mission.NAH_NuclearPowerValues[mechid].PrimePower
						elseif mechname == "Overload Mech" then
							counter = mission.NAH_NuclearPowerValues[mechid].BrutePower
						elseif mechname == "Recharge Mech" then
							counter = mission.NAH_NuclearPowerValues[mechid].SciencePower
						end
					elseif IsTestMechScenario() then
						counter = Materialize_Box.ScienceTestMechPower
					end
					if counter then
						for y = 1, 10 do
							if y <= counter then
								previewer:AddAnimation(curr, "NAH_on_"..y,1)
							elseif y <= counter + 1 then
								previewer:AddAnimation(curr, "NAH_plus_"..y,1)
							end
						end
					end
				end
				ret:AddScript([[
					local mission = GetCurrentMission()
					local curr = Point(]]..curr:GetString()..[[)
					if mission and Board:IsPawnTeam(curr,TEAM_PLAYER) then
						local mechid = Board:GetPawn(curr):GetId()
						if mechid >= 0 and mechid <= 2 and not IsTestMechScenario() then
							mission.NAH_NuclearPowerValues[mechid].PrimePower = mission.NAH_NuclearPowerValues[mechid].PrimePower + 1
							mission.NAH_NuclearPowerValues[mechid].BrutePower = mission.NAH_NuclearPowerValues[mechid].BrutePower + 1
							mission.NAH_NuclearPowerValues[mechid].SciencePower = mission.NAH_NuclearPowerValues[mechid].SciencePower + 1
							Board:Ping(curr, GL_Color(255, 224, 25))
						elseif IsTestMechScenario() then
							Materialize_Box.ScienceTestMechPower = Materialize_Box.ScienceTestMechPower + 1
							Board:Ping(curr, GL_Color(255, 224, 25))
						end
					end
				]])

			end
		end
	end

	local selfDamage = SpaceDamage(p1, self.SelfDamage)

	--selfDamage.sAnimation = "exploout0_0",--"ExploRepulse1" --Change Animation
	ret:AddDamage(selfDamage)

	return ret
end
