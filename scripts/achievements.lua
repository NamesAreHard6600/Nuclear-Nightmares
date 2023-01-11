--Stolen from tosx

local this = {}

local path = mod_loader.mods[modApi.currentMod].resourcePath
local modid = "NamesAreHard - Nuclear Nightmares"

function NAH_NN_Chievo(id)
	-- exit if not our squad
	if GAME.squadTitles["TipTitle_"..GameData.ach_info.squad] ~= "Nuclear Nightmares" then return end
	-- exit if current one is unlocked
	if modApi.achievements:getProgress(modid,id) then return end

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
	tip = "Four times during a single mission, kill an unwounded Vek with 4 or more health in one action.",
	img = "img/achievements/NAH_NN_a.png",
	squad = "NAH_NuclearNightmares",
}

modApi.achievements:add{
	id = "NAH_NN_recharge",
	name = "Recharge!",
	tip = "Regain 8 energy with one action of the fission generator.",
	img = "img/achievements/NAH_NN_b.png",
	squad = "NAH_NuclearNightmares",
}

modApi.achievements:add{
	id = "NAH_NN_conservative",
	name = "Conservative",
	tip = "Combust 3 Nuclear Boxes in one turn.",
	img = "img/achievements/NAH_NN_c.png",
	squad = "NAH_NuclearNightmares",
}

return this