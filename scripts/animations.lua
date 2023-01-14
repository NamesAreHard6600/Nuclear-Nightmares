local offset_x = -24
local offset_y = 28

for y = 1, 10 do
	ANIMS["NAH_flashing_"..y] = ANIMS.Animation:new{
		Image = "power/flashing.png",
		NumFrames = 6,
		Time = 0.10,
		PosX = offset_x,
		PosY = offset_y + y * -4
	}

	ANIMS["NAH_on_"..y] = ANIMS.Animation:new{
		Image = "power/on.png",
		PosX = offset_x,
		PosY = offset_y + y * -4,
		Time = 0.60
	}

	ANIMS["NAH_flashing_long_"..y] = ANIMS.Animation:new{
		Image = "power/flashing_long.png",
		NumFrames = 12,
		Time = 0.10,
		PosX = offset_x,
		PosY = offset_y + y * -4
	}

	ANIMS["NAH_on_long_"..y] = ANIMS.Animation:new{
		Image = "power/on.png",
		PosX = offset_x,
		PosY = offset_y + y * -4,
		Time = 1.20
	}

	ANIMS["NAH_on_short_"..y] = ANIMS.Animation:new{
		Image = "power/on.png",
		PosX = offset_x,
		PosY = offset_y + y * -4,
		Time = 0.5
	}

	ANIMS["NAH_plus_"..y] = ANIMS.Animation:new{
		Image = "power/plus.png",
		NumFrames = 6,
		PosX = offset_x,
		PosY = offset_y + y * -4,
		Time = 0.10
	}
	ANIMS["NAH_plus_long_"..y] = ANIMS.Animation:new{
		Image = "power/plus_long.png",
		NumFrames = 12,
		PosX = offset_x,
		PosY = offset_y + y * -4,
		Time = 0.10
	}
end
