extends Resource
class_name Interaction

var requirements: Array = []
var results: Dictionary = {}

func _init(dict):
	requirements.assign(dict["requirements"])
	results = dict["results"]

func process_interaction(interactions: Array[String]) -> Dictionary:
	var req_satisfied = true
	for req in requirements:
		req_satisfied = true
		if req is Array:
			for sub_req in req:
				if sub_req[0] == "_" and sub_req.substr(1) in interactions:
					req_satisfied = false
					break
				if not sub_req in interactions:
					req_satisfied = false
					break
			if req_satisfied:
				return results.duplicate(true)
			continue
		if req[0] == "_" and req.substr(1) in interactions:
			req_satisfied = false
			break
		if not req in interactions:
			req_satisfied = false
			break
	if req_satisfied:
		return results.duplicate(true)
	return {}

func evaluate_requirement(requirement, interactions: Array[String]) -> bool:
	for req in requirement:
		if req is Array and evaluate_requirement(req, interactions):
			continue
		if req[0] == "_" and not req.substr(1) in interactions:
			continue
		if req in interactions:
			continue
		return false
	return true
