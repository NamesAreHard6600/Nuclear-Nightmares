--NOTE: DO NOT USE THIS MOD FOR EXAMPLE PURPOSES. IT'S MY FIRST ONE AND IT'S A MESS, ESPECIALLY WITH THE WAY I IMPLEMENT TEST MECH SCENARIOS

--change test mech to not be excessive code. (I'm too lazy to do this)

--TODO
--Weird extra space on recharge: Has to do with Note in the hangar, but it's not a big deal

local function init(self)
	--init variables
	local path = mod_loader.mods[modApi.currentMod].scriptPath
	--libs
	local sprites = require(path .."libs/sprites")
	local palettes = require(self.scriptPath .."libs/customPalettes")
	local mod = mod_loader.mods[modApi.currentMod]
	local resourcePath = mod.resourcePath
	local scriptPath = mod.scriptPath
	local options = mod_loader.currentModContent[mod.id].options

	--[[ModApiExt
	if modApiExt then
		-- modApiExt already defined. This means that the user has the complete
		-- ModUtils package installed. Use that instead of loading our own one.
		NAH_NuclearNightmares_ModApiExt = modApiExt
	else
		-- modApiExt was not found. Load our inbuilt version
		local extDir = self.scriptPath.."modApiExt/"
		NAH_NuclearNightmares_ModApiExt = require(extDir.."modApiExt")
		NAH_NuclearNightmares_ModApiExt:init(extDir)
	end
	]]--
	self.libs = {}
	self.libs.modApiExt = modapiext
	self.libs.weaponPreview = require(self.scriptPath.."libs/".."weaponPreview")
	NAH_NuclearNightmares_ModApiExt = self.libs.modApiExt


	--Sprites
	sprites.addMechs(
		{
			Name = "nuclear_box",
			Default = {PosX = -18, PosY = -2},
			Death = {PosX = -18, PosY = -2, NumFrames = 1, Loop = false},
			Animated = {PosX = -18, PosY = -2, NumFrames = 2},
			Icon = {},
		},
		{
			Name = "Nuclear_Mech",
			Default = {PosX = -17, PosY = -6},
			Broken = {PosX = -17, PosY = -6, NumFrames = 1, Loop = true},
			Animated = {PosX = -17, PosY = -6, NumFrames = 4},
			Submerged = {PosX = -17, PosY = 10},
			SubmergedBroken = {PosX = -17, PosY = 7},
			Icon = {},
		},
		{
			Name = "Overload_Mech",
			Default = {PosX = -19, PosY = -6},
			Broken = {PosX = -19, PosY = -6, NumFrames = 1, Loop = true},
			Animated = {PosX = -19, PosY = -6, NumFrames = 4},
			Submerged = {PosX = -18, PosY = -1, NumFrames = 4},
			SubmergedBroken = {PosX = -18, PosY = -1},
			Icon = {},
		},
		{
			Name = "Recharge_Mech",
			Default = {PosX = -14, PosY = -15},
			Broken = {PosX = -17, PosY = -16, NumFrames = 1, Loop = true},
			Animated = {PosX = -14, PosY = -15, NumFrames = 8},
			Submerged = {PosX = -14, PosY = -1}, --Unused, cause flying, but I still need it
			SubmergedBroken = {PosX = -17, PosY = -12},
			Icon = {},
		}
	)

	--Palette
	if options["NAH_NN_PaletteHighlight"].value == "Cyan" then
		palettes.addPalette({
			ID = "NAH_NuclearNightmares",
			Name = "Nuclear Nightmares",
			PlateHighlight = { 35, 248, 255}, --{  6, 255,  50},
			PlateLight     = {221, 188,  65}, --{219, 204,  86},
			PlateMid       = {159, 128,  62}, --{212, 212,   0},
			PlateDark      = { 74,  64,  53}, --{189, 167,   0},
			PlateOutline   = { 15,  22,  16}, --{  2,   2,   1},
			PlateShadow    = { 69,  74,  57}, --{ 16,  17,  16},
			BodyColor      = {109, 109,  94},
			BodyHighlight  = {152, 153, 131},
		})
	else
		palettes.addPalette({
			ID = "NAH_NuclearNightmares",
			Name = "Nuclear Nightmares",
			PlateHighlight = {  6, 255,  50}, --{ 35, 248, 255},
			PlateLight     = {221, 188,  65}, --{219, 204,  86},
			PlateMid       = {159, 128,  62}, --{212, 212,   0},
			PlateDark      = { 74,  64,  53}, --{189, 167,   0},
			PlateOutline   = { 15,  22,  16}, --{  2,   2,   1},
			PlateShadow    = { 69,  74,  57}, --{ 16,  17,  16},
			BodyColor      = {109, 109,  94},
			BodyHighlight  = {152, 153, 131},
		})
	end

	--Scripts
	require(self.scriptPath.."weapons")
	require(self.scriptPath.."pawns")
	require(self.scriptPath.."animations")
	require(self.scriptPath.."hooks")
	require(self.scriptPath.."tips")
	require(self.scriptPath.."achievements")

	--Weapon Texts
	modApi:addWeapon_Texts(require(self.scriptPath .. "weapons_text"))

	--Weapon Icons
	modApi:appendAsset("img/weapons/NuclearFistIcon.png",self.resourcePath.."img/weapons/NuclearFistIcon.png")
	modApi:appendAsset("img/weapons/BoxDropIcon.png",self.resourcePath.."img/weapons/BoxDropIcon.png")
	modApi:appendAsset("img/weapons/NuclearBeamIcon.png",self.resourcePath.."img/weapons/NuclearBeamIcon.png")
	modApi:appendAsset("img/weapons/FissionGeneratorIcon.png",self.resourcePath.."img/weapons/FissionGeneratorIcon.png")
	modApi:appendAsset("img/weapons/CombustionIcon.png",self.resourcePath.."img/weapons/CombustionIcon.png")
	modApi:appendAsset("img/effects/nuclear_box.png",self.resourcePath.."img/effects/nuclear_box.png")
		Location["effects/nuclear_box.png"] = Point(-99,-99)

	--Power Icons
	modApi:appendAsset("img/power/on.png", self.resourcePath.."img/power/on.png")
	modApi:appendAsset("img/power/flashing.png", self.resourcePath.."img/power/flashing.png")
	modApi:appendAsset("img/power/flashing_long.png", self.resourcePath.."img/power/flashing_long.png")
	modApi:appendAsset("img/power/plus.png", self.resourcePath.."img/power/plus.png")
	modApi:appendAsset("img/power/plus_long.png", self.resourcePath.."img/power/plus_long.png")

	--[[ Deprecated
	local shop = require(self.scriptPath .."libs/shop")
	shop:addWeapon({
		id = "Nuclear_Punch",
		name = "Nuclear Punch",
		desc = "Adds Nuclear Punch to the Store"
	})
	shop:addWeapon({
		id = "Nuclear_Beam",
		name = "Nuclear Beam",
		desc = "Adds Nuclear Beam to the Store"
	})
	--]]
	modApi:addWeaponDrop{id = "Nuclear_Punch", pod = true, shop = true }
	modApi:addWeaponDrop{id = "Nuclear_Beam", pod = true, shop = true }
	--The other two weapons are pretty much complelty useless, especially the generator
	--But they're added if you want to use them, just off by default
	modApi:addWeaponDrop{id = "Fission_Generator", pod = false, shop = false }
	modApi:addWeaponDrop{id = "Materialize_Box", pod = false, shop = false }
end
local function load(self,options,version)
	require(self.scriptPath .. "hooks"):load(NAH_NuclearNightmares_ModApiExt)
	require(self.scriptPath .. "ach_hooks"):load(NAH_NuclearNightmares_ModApiExt)


	modApi:addSquadTrue({"Nuclear Nightmares", "NAH_NuclearMech", "NAH_OverloadMech", "NAH_RechargeMech", id = "NAH_NuclearNightmares"}, "Nuclear Nightmares", "Taking nuclear Energy with them, these mechs are the Vek's worst nightmare, as long as you have the Energy.",self.resourcePath.."/squadIcon.png")

	if options.resetTutorials and options.resetTutorials.enabled then
		require(self.scriptPath .."libs/tutorialTips"):ResetAll()
		options.resetTutorials.enabled = false
	end
end

local function metadata()
	modApi:addGenerationOption("NAH_NN_AttackOrder", "Attack Order Shows Energy", "Turn on or off whether or not pressing the attack order hotkey shows mechs Energy.", {values = {"On","Off"}})
	modApi:addGenerationOption("NAH_NN_PaletteHighlight", "Plate Highlight Color", "Choose the color of the plate highlight in the Nuclear Nightmares color palette. YOU MUST RESTART THE GAME FOR CHANGES TO TAKE AFFECT", {values = {"Cyan", "Lime"}})
	modApi:addGenerationOption(
		"resetTutorials",
		"Reset Tutorial Tooltips",
		"Check to reset all tutorial tooltips for this profile.",
		{ enabled = false }
	)
end


return {
  id = "NamesAreHard - Nuclear Nightmares",
  name = "Nuclear Nightmares",
	icon = "modIcon.png",
	description = "Taking nuclear Energy with them, these mechs are the Vek's worst nightmare, as long as you have the Energy.",
	modApiVersion = "2.8.0",
	gameVersion = "1.2.83",
	version = "1.1.0",
	requirements = { "kf_ModUtils" },
	dependencies = {
		modApiExt = "1.17",
	},
  metadata = metadata,
	load = load,
	init = init
}
