--Stolen from tosx

local this = {}

local path = mod_loader.mods[modApi.currentMod].resourcePath
local modid = "NamesAreHard - Nuclear Nightmares"

function NAH_NN_Chievo(id)
	-- exit if not our squad
	if GAME.squadTitles["TipTitle_"..GameData.ach_info.squad] ~= "Nuclear Nightmares" then return end
	-- exit if current one is unlocked
	if modApi.achievements:isComplete(modid,id) then return end

	modApi.achievements:trigger(modid,id)
end

local imgs = {
	"a",
	"b",
	"c",
}

local achname = "NAH_NN_"
for _, img in ipairs(imgs) do
	modApi:appendAsset("img/achievements/".. achname..img ..".png", path .."img/achievements/".. achname..img ..".png")
	modApi:appendAsset("img/achievements/".. achname..img .."_gray.png", path .."img/achievements/".. achname..img .."_gray.png")
end

modApi.achievements:add{
	id = "NAH_NN_oneshot",
	name = "One Punch Mech",
	tip = "Four times during a single mission, kill an unwounded Vek that has 4 or more health with Nuclear Punch.\n$ Killed",
	img = "img/achievements/NAH_NN_a.png",
	squad = "NAH_NuclearNightmares",
	objective = 4, --Can break with reset turns but I don't care enough right now
}

modApi.achievements:add{
	id = "NAH_NN_recharge",
	name = "Recharge!",
	tip = "Regain 8 energy with one action of the fission generator.",
	img = "img/achievements/NAH_NN_b.png",
	squad = "NAH_NuclearNightmares",
	objective = 1,
}

modApi.achievements:add{
	id = "NAH_NN_conservative",
	name = "Planning Ahead",
	tip = "Combust 3 Nuclear Boxes in one turn.\n$ Combusted",
	img = "img/achievements/NAH_NN_c.png",
	squad = "NAH_NuclearNightmares",
	objective = 3,
}

return this
