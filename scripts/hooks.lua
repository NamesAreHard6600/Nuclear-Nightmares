local path = mod_loader.mods[modApi.currentMod].resourcePath
local mod = mod_loader.mods[modApi.currentMod]
local resourcePath = mod.resourcePath
local scriptPath = mod.scriptPath
local previewer = mod.libs.weaponPreview
local hotkey = require(scriptPath.."libs/hotkey")
local function IsTipImage()
	return Board:GetSize() == Point(6,6)
end

local this = {}

local function startHook(mission)
	mission.NAH_NuclearPowerValues = mission.NAH_NuclearPowerValues or {}
	for i = 0, 2 do
		if Board and Board:GetPawn(i) then
			mission.NAH_NuclearPowerValues[i] = {
				PrimePower = Nuclear_Punch.MaxPrimePower,
				BrutePower = Nuclear_Beam.MaxBrutePower,
				SciencePower = Materialize_Box.MaxSciencePower,
			}
		end
	end
	--LOG(mission)
end

local function FinalIslandPhaseTwoHook(prevMission, nextMission)
	nextMission.NAH_NuclearPowerValues = nextMission.NAH_NuclearPowerValues or {}
	for i = 0, 2 do
		nextMission.NAH_NuclearPowerValues[i] = {
			PrimePower = Nuclear_Punch.MaxPrimePower,
			BrutePower = Nuclear_Beam.MaxBrutePower,
			SciencePower = Materialize_Box.MaxSciencePower,
		}
	end
	--LOG(nextMission)
end

local function TestStartHook(mission)
	Nuclear_Punch.PrimeTestMechPower = Nuclear_Punch.MaxPrimePower
	Nuclear_Beam.BruteTestMechPower = Nuclear_Beam.MaxBrutePower
	Materialize_Box.ScienceTestMechPower = Materialize_Box.MaxSciencePower
end

local function StartTurnHook(mission)
	if Game:GetTeamTurn() == TEAM_PLAYER then
		local point
		for mechId = 0, 2 do
			local extra = 0
			if Board and Board:GetPawn(mechId) then
				point = Board:GetPawnSpace(mechId) --Pawn:GetSpace(mechId)
			else
				point = Point(-5,-5)
			end
			--LOG(point)
			for i = DIR_START, DIR_END do
				local curr = DIR_VECTORS[i]*1 + point
				--LOG(curr)
				local pawn = Board:GetPawn(curr)
				if pawn then
					local pawnName = pawn:GetType()
					if pawnName == "NuclearBox" or pawnName == "NuclearBoxA" or pawnName == "NuclearBoxB" or pawnName == "NuclearBoxAB" then
						extra = extra + 1
					end
				end
			end
			if extra > 0 then
				mission.NAH_NuclearPowerValues[mechId].PrimePower = mission.NAH_NuclearPowerValues[mechId].PrimePower + extra
				mission.NAH_NuclearPowerValues[mechId].BrutePower = mission.NAH_NuclearPowerValues[mechId].BrutePower + extra
				mission.NAH_NuclearPowerValues[mechId].SciencePower = mission.NAH_NuclearPowerValues[mechId].SciencePower + extra
				Board:Ping(point, GL_Color(255, 224, 25))
			end
		end
	end
end

local function attackOrder(keycode)
	local mission = GetCurrentMission()
	if keycode == hotkey.keys[hotkey["ATTACK_ORDER_OVERLAY"]] and NAH_NN_AttackOrder == "On" then
		if mission and not sdlext.isConsoleOpen() then
			local board_size = Board:GetSize()
			for i = 0, board_size.x - 1 do
				for j = 0, board_size.y - 1  do
					if mission and Board:IsPawnTeam(Point(i,j),TEAM_PLAYER) then
						local pawn_id = Board:GetPawn(Point(i,j)):GetId()
						local pawn_name = Board:GetPawn(Point(i,j)):GetMechName()
						if pawn_id >= 0 and pawn_id <= 2 then
							previewer:SetLooping(true)
							local counter = 0
							if pawn_name == "Nuclear Mech" then
								if not IsTipImage() and not IsTestMechScenario() then
									counter = mission.NAH_NuclearPowerValues[pawn_id].PrimePower
								elseif IsTestMechScenario() and not IsTipImage() then
									counter = Nuclear_Punch.PrimeTestMechPower
								end
							elseif pawn_name == "Overload Mech" then
								if not IsTipImage() and not IsTestMechScenario() then
									counter = mission.NAH_NuclearPowerValues[pawn_id].BrutePower
								elseif IsTestMechScenario() and not IsTipImage() then
									counter = Nuclear_Beam.BruteTestMechPower
								end
							elseif pawn_name == "Recharge Mech" then
								if not IsTipImage() and not IsTestMechScenario() then
									counter = mission.NAH_NuclearPowerValues[pawn_id].SciencePower
								elseif IsTestMechScenario() and not IsTipImage() then
									counter = Materialize_Box.ScienceTestMechPower
								end
							end
							for y = 1, 10 do
								if y > counter then
									break
								else
									Board:AddAnimation(Point(i,j),"NAH_on_short_"..y,.01)
									--LOG(counter)
								end
							end
						end
					end
				end
			end
		end
	end
end

function this:load(NAH_NuclearNightmares_ModApiExt)
	local options = mod_loader.currentModContent[mod.id].options

	NAH_NN_AttackOrder = options["NAH_NN_AttackOrder"].value
    modApi:addMissionStartHook(startHook)
	modApi:addTestMechEnteredHook(TestStartHook)
	--modApi:addNextTurnHook(StartTurnHook) BOX CHANGED, NO LONGER USED
	modApi:addMissionNextPhaseCreatedHook(FinalIslandPhaseTwoHook)
	sdlext.addPreKeyDownHook(attackOrder)

end

return this
