extends AtlasTexture

@export var h_images = 4
@export var v_images = 4
@export var sub_width = 16
@export var sub_height = 16

func set_colour(index: int):
	self.region = Rect2(
		sub_width*(index%h_images), 
		sub_height*(floor(float(index)/v_images)), 
		sub_width, 
		sub_height
	)
