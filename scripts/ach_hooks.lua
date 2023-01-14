--A better method is to have them together like in Vextra so there's less extra words
--But that would be a lot of changing things around

local path = mod_loader.mods[modApi.currentMod].resourcePath
local mod = mod_loader.mods[modApi.currentMod]
local resourcePath = mod.resourcePath
local scriptPath = mod.scriptPath
local previewer = mod.libs.weaponPreview
local hotkey = require(scriptPath.."libs/hotkey")
local modid = "NamesAreHard - Nuclear Nightmares"

local function IsTipImage()
	return Board:GetSize() == Point(6,6)
end

local this = {}

-- Helper Functions
local function isGame()
	return true
		and Game ~= nil
		and GAME ~= nil
end

local function isMission()
	local mission = GetCurrentMission()

	return true
		and isGame()
		and mission ~= nil
		and mission ~= Mission_Test
end

local function isMissionBoard()
	return true
		and isMission()
		and Board ~= nil
		and Board:IsTipImage() == false
end

local function IsAchValid(achid)
	return true
	 and not modApi.achievements:isComplete(modid,achid)
	 and GAME.squadTitles["TipTitle_"..GameData.ach_info.squad] == "Nuclear Nightmares"
	 and isMissionBoard()
end


--------- RESETING FUNCTIONS ---------
local function ResetConservativeVars(mission)
	modApi.achievements:addProgress(modid,"NAH_NN_conservative",-modApi.achievements:getProgress(modid,"NAH_NN_conservative"))
end

local function ResetOneShotVars(mission)
	modApi.achievements:addProgress(modid,"NAH_NN_oneshot",-modApi.achievements:getProgress(modid,"NAH_NN_oneshot"))
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
	if IsAchValid("NAH_NN_conservative") then
		ResetConservativeVars(mission)
	end
	if IsAchValid("NAH_NN_oneshot") then
		mission.NAH_OS_ResetTurn = 0
		ResetOneShotVars(mission)
	end
end
local function MissionEndHook(mission)
	MissionStartHook(mission)
end

local function PhaseStartHook(_, nextMission)
	MissionStartHook(nextMission)
end

local function TurnStartHook(mission)
	if IsAchValid("NAH_NN_oneshot") then
		mission.NAH_OS_ResetTurn = 0
	end
	if IsAchValid("NAH_NN_conservative") and Game:GetTeamTurn() == TEAM_PLAYER then
		ResetConservativeVars(mission)
	end
end

local function ResetTurnHook(mission)
	if IsAchValid("NAH_NN_oneshot") then --Reset Turn Fixing
		modApi.achievements:addProgress(modid,"NAH_NN_oneshot",-mission.NAH_OS_ResetTurn)
	end
	if IsAchValid("NAH_NN_conservative") then
		ResetConservativeVars(mission)
	end
end

local NAH_NuclearPunchAttack = false


--------- ACTUAL CHECKS ---------
local function SkillEndHook(mission, pawn, weaponId, p1, p2)
	if IsAchValid("NAH_NN_oneshot") then
		modApi:scheduleHook(500, function()
			if weaponId:find("^Nuclear_Punch") then
				NAH_NuclearPunchAttack = false
			end
		end)
	end
	if IsAchValid("NAH_NN_conservative") then
		if weaponId == "Combustion" or weaponId == "Combustion2" then
			modApi.achievements:addProgress(modid,"NAH_NN_conservative",1)
		end
	end
end


local function SkillStartHook(mission, pawn, weaponId, p1, p2)
	if IsAchValid("NAH_NN_oneshot") then
		if IsAchValid("NAH_NN_oneshot") then
			if weaponId:find("^Nuclear_Punch") then
				NAH_NuclearPunchAttack = true
			end
		end
		UpdateOneShot(mission) --I update one shot table every skill used in case there's regen or something like that.
	end
end

local function PawnKilledHook(mission, pawn)
	if IsAchValid("NAH_NN_oneshot") and pawn:GetTeam() == TEAM_ENEMY and NAH_NuclearPunchAttack then
		local id = pawn:GetId()
		if not mission.NAH_NN_VekTable[id] then
			LOG("IF THIS SHOWS UP, @NamesAreHard ON THE ITB DISCORD TY")
		elseif mission.NAH_NN_VekTable[id].isMax and mission.NAH_NN_VekTable[id].health >= 4 then
			mission.NAH_OS_ResetTurn = mission.NAH_OS_ResetTurn + 1
			modApi.achievements:addProgress(modid,"NAH_NN_oneshot",1)
		end
	end
end





function this:load(NAH_NuclearNightmares_ModApiExt)
	local options = mod_loader.currentModContent[mod.id].options

  modApi:addMissionStartHook(MissionStartHook)
	modApi:addMissionNextPhaseCreatedHook(PhaseStartHook)
	modApi:addMissionEndHook(MissionEndHook)
	modApi:addNextTurnHook(TurnStartHook)
	NAH_NuclearNightmares_ModApiExt:addSkillEndHook(SkillEndHook)
	NAH_NuclearNightmares_ModApiExt:addResetTurnHook(ResetTurnHook)
	NAH_NuclearNightmares_ModApiExt:addSkillStartHook(SkillStartHook)
	NAH_NuclearNightmares_ModApiExt:addPawnKilledHook(PawnKilledHook)

end

return this
