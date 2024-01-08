extends AtlasTexture

@export var h_images = 4
@export var v_images = 4
@export var sub_width = 16
@export var sub_height = 16
var current_index = 0

func _init():
	region = Rect2(0, 0, sub_width, sub_height)

func set_colour(index: int):
	self.current_index = index
	self.region = Rect2(
		sub_width*(index%h_images), 
		sub_height*(floor(float(index)/h_images)), 
		sub_width, 
		sub_height
	)

func set_texture(path: String):
	self.set_atlas(load(path)) 
