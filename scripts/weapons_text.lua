local Weapon_Texts = {

	--Nuclear Punch
	Nuclear_Punch_Name = "Nuclear Punch",
	Nuclear_Punch_Description = "Pushes an adjacent target and deals damage equal to Energy, then decreases Energy by 1. Starting Energy 3.",
	Nuclear_Punch_DamageTip = "Energy", -- NOT NECCESARY, BUT IT'S HERE
	Nuclear_Punch_Upgrade1 = "+1 Damage",
	Nuclear_Punch_A_UpgradeDescription = "Increases damage by 1",

	--Nuclear Beam
	Nuclear_Beam_Name = "Nuclear Beam",
	Nuclear_Beam_Description = "Pushes and damages targets in a line. Covers a chosen number of tiles, up to Energy, then decreases Energy by that amount. Starting Energy 6.",
	Nuclear_Beam_Upgrade1 = "-1 Energy Used",
	Nuclear_Beam_A_UpgradeDescription = "Decreases the Energy used per activation by 1.",
	Nuclear_Beam_Upgrade2 = "+1 Damage",
	Nuclear_Beam_B_UpgradeDescription = "Increases Damage by 1.",

	--Materialize Box
	Materialize_Box_Name = "Materialize Box",
	Materialize_Box_Description = "Deploy a 1 health box within a range equal to your Energy, then decreases Energy by 1. The box has the ability to combust, dealing itself one self damage, pushing adjacent units. Starting Energy 3.",
	Materialize_Box_Upgrade1 = "Super Charged",
	Materialize_Box_A_UpgradeDescription = "When combusting, the box also provides one Energy to any mech in its row or column.",
	Materialize_Box_Upgrade2 = "+1 Health",
	Materialize_Box_B_UpgradeDescription = "Increases Health by 1",

	--Fission Generator
	Fission_Generator_Name = "Fission Generator",
	Fission_Generator_Description = "Restores the Energy of all weapons in one mech to their Starting Energy.",
	Fission_Generator_Upgrade1 = "+2 Energy Gain",
	Fission_Generator_A_UpgradeDescription = "Increases the Energy restored by 2, meaning you'll get 2 more than its Starting Energy.",
	Fission_Generator_Upgrade2 = "Reactivate",
	Fission_Generator_B_UpgradeDescription = "Allows the mech to take an extra action after use. No extra movement.",

	--Combustion
	Combustion_Name = "Combustion",
	Combustion_Description = "A slight explosion pushes units in all four directions.",

	Combustion2_Name = "Super Combustion",
	Combustion2_Description = "A slight explosion pushes units in all four directions. Gives Energy to mechs in its row or column."

	--CombustionUpgraded_Name = "Combustion",
	--Combustion_Description = "A slight explosion pushes units in all four directions."
}
return Weapon_Texts
