extends Control

@onready var Spotlight = %Spotlight
@onready var Text = %Text
@onready var Focus: Node = null

const SPOTLIGHT_MARGIN: Vector2 = Vector2(2, 2)

func focus_spotlight_on_node(node: Control):
	Focus = node
	Spotlight.set_global_position(node.get_screen_position())
	Spotlight.set_size(node.size)

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
	
