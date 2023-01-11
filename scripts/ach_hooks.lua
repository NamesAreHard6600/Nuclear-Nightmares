local path = mod_loader.mods[modApi.currentMod].resourcePath
local mod = mod_loader.mods[modApi.currentMod]
local resourcePath = mod.resourcePath
local scriptPath = mod.scriptPath
local previewer = require(scriptPath.."weaponPreview/api")
local hotkey = require(scriptPath.."libs/hotkey")

local function IsTipImage()
	return Board:GetSize() == Point(6,6)
end

local this = {}


--------- RESETING FUNCTIONS ---------
local function ResetConservativeVars(mission)
	mission.NAH_NN_Combust = 0
end

local function ResetOneShotVars(mission)
	mission.NAH_NN_OneShot = mission.NAH_NN_OneShot or 0
	mission.NAH_NN_VekTable = mission.NAH_NN_VekTable or {}
end

local function OneShotUpdatePawn(mission, id)
	local pawn = Board:GetPawn(id)
	mission.NAH_NN_VekTable[id] = {
		isMax = not pawn:IsDamaged(), --Is true if at max, is false if not at max
		health = pawn:GetHealth()
	} 
end

local function UpdateOneShot(mission)
	local board_size = Board:GetSize()
	for i = 0, board_size.x - 1 do
		for j = 0, board_size.y - 1  do
			local curr = Point(i,j)
			local pawn = Board:GetPawn(curr)
			if pawn and pawn:GetTeam() == TEAM_ENEMY then
				OneShotUpdatePawn(mission, pawn:GetId())
			end
		end
	end
end



--------- RESETING HOOKS ---------
local function MissionStartHook(mission)
	ResetConservativeVars(mission)
	ResetOneShotVars(mission)
end

local function PhaseStartHook(_, nextMission)
	MissionStartHook(nextMission)
end

local function TurnStartHook(mission)
	if Game:GetTeamTurn() == TEAM_PLAYER then
		ResetConservativeVars(mission)
	end
end

--------- ACTUAL CHECKS ---------
local function SkillEndHook(mission, pawn, weaponId, p1, p2)
	if IsTestMechScenario() or IsTipImage() then return end
	if weaponId == "Combustion" or weaponId == "Combustion2" then
		mission.NAH_NN_Combust = mission.NAH_NN_Combust + 1
		if mission.NAH_NN_Combust >= 3 then
			NAH_NN_Chievo("NAH_NN_conservative")
		end
	end
end


local function SkillStartHook(mission, pawn, weaponId, p1, p2) 
	UpdateOneShot(mission) --I update one shot table every skill used in case there's regen or something like that. 
end

local function PawnKilledHook(mission, pawn)
	local id = pawn:GetId()
	if mission.NAH_NN_VekTable[id].isMax and mission.NAH_NN_VekTable[id].health >= 4 then
		mission.NAH_NN_OneShot = mission.NAH_NN_OneShot + 1
		if mission.NAH_NN_OneShot >= 4 then
			NAH_NN_Chievo("NAH_NN_oneshot")
		end
	end
end





function this:load(NAH_NuclearNightmares_ModApiExt)
	local options = mod_loader.currentModContent[mod.id].options
	
    modApi:addMissionStartHook(MissionStartHook)
	modApi:addMissionNextPhaseCreatedHook(PhaseStartHook)
	modApi:addNextTurnHook(TurnStartHook)
	NAH_NuclearNightmares_ModApiExt:addSkillEndHook(SkillEndHook)
	
	NAH_NuclearNightmares_ModApiExt:addSkillStartHook(SkillStartHook)
	NAH_NuclearNightmares_ModApiExt:addPawnKilledHook(PawnKilledHook)
	
end

return this