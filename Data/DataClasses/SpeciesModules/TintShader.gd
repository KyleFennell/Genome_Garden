extends SpeciesModule

const type = "TintShader"
const TintShader = preload("res://Resources/Shaders/tint.tres")
var shader: ShaderMaterial

func _init(data: Dictionary, modules: Array):
	super._init(data, modules)
	
func create_on(root: Node):
	self.shader = ShaderMaterial.new()
	self.shader.shader = TintShader.duplicate()
	if not self.parent.node.has_method("set_material"):
		print("ERROR: cannot create TintShader on parent: ", parent.name)
		return
	self.parent.node.set_material(self.shader)
	process_attributes(self.initial_params)
	
func process_attributes(dict: Dictionary):
	for attr in dict:
		var value = dict[attr]
		match attr:
			"colour_mode": 
				if value == "hsv":
					shader.set_shader_parameter("HSV", true)
			"colour":
				var colour = Vector4(
						value.get("r", 1.0),
						value.get("g", 1.0),
						value.get("b", 1.0),
						value.get("a", 1.0)
					)
				shader.set_shader_parameter("Colour", colour)
				print("set shader colour: ", colour)
			"r":
				var current_colour: Vector4 = shader.get_shader_parameter("Colour")
				current_colour.x = value
				shader.set_shader_parameter("Colour", current_colour)
			"g":
				var current_colour: Vector4 = shader.get_shader_parameter("Colour")
				current_colour.y = value
				shader.set_shader_parameter("Colour", current_colour)
			"b":
				var current_colour: Vector4 = shader.get_shader_parameter("Colour")
				current_colour.z = value
				shader.set_shader_parameter("Colour", current_colour)
			"a":
				var current_colour: Vector4 = shader.get_shader_parameter("Colour")
				current_colour.w = value
				shader.set_shader_parameter("Colour", current_colour)

func update_node():
	self.node.set_texture(self.texture)
