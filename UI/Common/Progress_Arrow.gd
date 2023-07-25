extends AtlasTexture

const FRAMES = 6

func set_percent(perc: float):
	var frame = 0
	if perc > 0:
		frame = ceil(perc*(FRAMES-1))
	self.region = Rect2(16*frame, 0, 16, 16)
