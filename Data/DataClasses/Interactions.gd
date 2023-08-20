extends Resource
class_name Interaction

var default: Dictionary = {}
var values: Dictionary = {}
var name: String = ""

func _init(dict):
	name = dict["name"]
	default = dict["default"]
	values = dict.get("values", {})

func get_properties(value) -> Dictionary:
	value = str(value)
	return values[value] if value in values else default
