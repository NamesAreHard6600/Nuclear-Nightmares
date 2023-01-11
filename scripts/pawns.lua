local path = mod_loader.mods[modApi.currentMod].scriptPath
local palettes = require(path.."libs/customPalettes")

local pawnColor = palettes.getOffset("NAH_NuclearNightmares")
--Mechs
--Nuclear Mech
NAH_NuclearMech = Pawn:new {
	Name = "Nuclear Mech",
	Class = "Prime",
	Image = "Nuclear_Mech",
	ImageOffset = pawnColor,
	Health = 3,
	MoveSpeed = 3,
	SkillList = {"Nuclear_Punch"},
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	SoundLocation = "/mech/prime/punch_mech/",
	Massive = true,
	Flying = false
}
AddPawn("NAH_NuclearMech")
--Atomic Mech
NAH_OverloadMech = Pawn:new {
	Name = "Overload Mech",
	Class = "Brute",
	Image = "Overload_Mech",
	ImageOffset = pawnColor,
	Health = 2,
	MoveSpeed = 3,
	SkillList = {"Nuclear_Beam"},
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	SoundLocation = "/mech/prime/laser_mech/",
	Massive = true,
	Flying = false
}
AddPawn("NAH_OverloadMech")
--Recharge Mech
NAH_RechargeMech = Pawn:new {
	Name = "Recharge Mech",
	Class = "Science",
	Image = "Recharge_Mech",
	ImageOffset = pawnColor,
	Health = 3,
	MoveSpeed = 4,
	SkillList = {"Materialize_Box", "Fission_Generator"},
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
	SoundLocation = "/mech/science/science_mech/",
	Flying = true
}
AddPawn("NAH_RechargeMech")

--Box
--[[Box = Pawn:new{
	Name = "Box",
	DefaultTeam = Team_Neutral,
	Massive = false,
	Health = 1,
	MoveSpeed = 0,
	Armor = false,
	Image = "box",
	ImpactMaterial = IMPACT_METAL,
	Corpse = false,
	IsPortrait = false,
}
AddPawn("Box") 
BoxA = Pawn:new{
	Name = "BoxA",
	DefaultTeam = Team_Neutral,
	Massive = false,
	Health = 2,
	MoveSpeed = 0,
	Armor = false,
	Image = "box",
	ImpactMaterial = IMPACT_METAL,
	Corpse = false,
	IsPortrait = false,
}
AddPawn("BoxA") 
--]]

NAH_NuclearBox = Pawn:new{
	Name = "Nuclear Box",
	DefaultTeam = TEAM_PLAYER,
	Massive = false,
	Health = 1,
	MoveSpeed = 0,
	SkillList = { "Combustion" },
	Armor = false,
	Image = "nuclear_box",
	ImageOffset = nil,
	ImpactMaterial = IMPACT_METAL,
	Corpse = false,
}
AddPawn("NAH_NuclearBox")  
NAH_NuclearBoxA = Pawn:new{
	Name = "Nuclear Box",-- Remove letters
	DefaultTeam = TEAM_PLAYER,
	Massive = false,
	Health = 1,
	MoveSpeed = 0,
	SkillList = { "Combustion2" },
	Armor = false,
	Image = "nuclear_box",
	ImageOffset = nil,
	ImpactMaterial = IMPACT_METAL,
	Corpse = false,
}
AddPawn("NAH_NuclearBoxA") 
NAH_NuclearBoxB = Pawn:new{
	Name = "Nuclear Box",
	DefaultTeam = TEAM_PLAYER,
	Massive = false,
	Health = 2,
	MoveSpeed = 0,
	SkillList = { "Combustion" },
	Armor = false,
	Image = "nuclear_box",
	ImageOffset = nil,
	ImpactMaterial = IMPACT_METAL,
	Corpse = false,
}
AddPawn("NAH_NuclearBoxB") 
NAH_NuclearBoxAB = Pawn:new{
	Name = "Nuclear Box",
	DefaultTeam = TEAM_PLAYER,
	Massive = false,
	Health = 2,
	MoveSpeed = 0,
	SkillList = { "Combustion2" },
	Armor = false,
	Image = "nuclear_box",
	ImageOffset = nil,
	ImpactMaterial = IMPACT_METAL,
	Corpse = false,
}
AddPawn("NAH_NuclearBoxAB") 