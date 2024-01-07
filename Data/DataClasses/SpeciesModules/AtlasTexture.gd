extends SpeciesModule

const type = "TextureAtlas"
var atlas: AtlasTexture = preload("res://Resources/SubTexture.gd").new()
var texture: Texture
var default_sub_texture: int = 0
var width: int = 4
var height: int = 4

func _init(data: Dictionary, modules: Array):
	super._init(data, modules)
	var params = data.get("params", {})
	self.default_sub_texture = params.get("default_sub_texture", 0)
	self.texture = load(params.get("path"))
	self.width = params.get("width", 4)
	self.height = params.get("height", 4)

func create_on(root: Node):
	self.node = TextureRect.new()	
	self.atlas.atlas = texture
	self.atlas.h_images = height
	self.atlas.v_images = width
	set_sub_texture_value(self.default_sub_texture)
	self.node.set_texture(self.atlas)
	super.create_on(root)

func set_sub_texture_value(value):
	self.atlas.set_colour(value)

func process_attributes(dict: Dictionary):
	for attr in dict:
		var value = dict[attr]
		match attr:
			"sub_texture": set_sub_texture_value(value)
			"texture_path": 
				texture = load(value)
				self.atlas.atlas = texture
			"hidden":
				if value:
					self.node.hide()
				else:
					self.node.show()

func update_node():
	self.node.set_texture(self.atlas)
