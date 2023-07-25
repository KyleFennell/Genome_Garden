extends Control

@onready var Spotlight = %Spotlight
@onready var Text = %Text

const SPOTLIGHT_MARGIN: Vector2 = Vector2(2, 2)

class SpotlightParameters:
	var position: Vector2
	var size: Vector2
	var node: Node
	
	func _init(params):
		node = params.get("node", null)
		if node:
			position = node.position
			size = node.size + Vector2(1, 1)
		else:
			position = params.get("position", Vector2(0, 0))
			size = params.get("size", Vector2(41, 41))
		position -= SPOTLIGHT_MARGIN
		size += SPOTLIGHT_MARGIN
func _set_spotlight_parameters
