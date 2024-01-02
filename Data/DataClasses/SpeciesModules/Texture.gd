extends SpeciesModule

const type = "Texture"
var texture: Texture

func _init(data: Dictionary, modules: Array):
	super._init(data, modules)
	self.texture = load(data.get("path"))
	
func create_on(root: Node):
	self.node = TextureRect.new()
	self.node.set_texture(self.texture)
	super.create_on(root)

func process_attributes(dict: Dictionary):
	for attr in dict:
		var value = dict[attr]
		match attr:
			"texture_path": 
				self.texture = load(value)

func update_node():
	self.node.set_texture(self.texture)
