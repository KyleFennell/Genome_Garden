extends Resource
class_name HiddenCombination

var parent1: Item = null
var parent2: Item = null
var child: Item = null
var chance: float = 1.0
var discovered: bool = false

func _init(data):
	parent1 = data["parent1"]
	parent2 = data["parent2"]
	child = data["child"]
	chance = data["chance"]

func check_match(p1, p2):
	if p1.equals(parent1):
		return p2.equals(parent2)
	elif p2.equals(parent1):
		return p1.equals(parent2)
	return false
