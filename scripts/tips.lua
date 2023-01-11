local mod = mod_loader.mods[modApi.currentMod]
local path = mod.scriptPath
local tips = require(path .."libs/tutorialTips")

tips:Add{
	id = "Energy",
	title = "Energy",
	text = "The Nuclear Nightmares require Energy to function, and each weapon has its own Energy. The amount of starting Energy, how much is used, and what purpose it serves is all based on the weapon and is in its description. Energy is displayed when selecting the weapon, and you can also show the weapons Energy values by pressing the attack order hotkey (toggleable in the options)."
}

tips:Add{
	id = "GainEnergy",
	title = "Gaining Energy",
	text = "The Fission Generator allows mechs to gain Energy back. It provides Energy to all weapons in a mech, and the mechs current Energy and how much will be gained will be displayed."
}
