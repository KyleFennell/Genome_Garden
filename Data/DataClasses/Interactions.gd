extends Resource
class_name Interaction

var requirements: Array[String] = []
var results: Dictionary = {}

func _init(dict):
	requirements.assign(dict["requirements"])
	results = dict["results"]

func process_interaction(interactions) -> Dictionary:
	for req in requirements:
		if req[0] == "_" and not req.substr(1) in interactions:
			continue
		if req in interactions:
			continue
		return {}
	return results.duplicate(true)
