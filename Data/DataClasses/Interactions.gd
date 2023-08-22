extends Resource
class_name Interaction

var name: String = ""
var default: Dictionary = {}
var parameters: Dictionary = {}
var presentations: Dictionary = {}

func _init(dict):
	name = dict["name"]
	default = dict.get("default", {})
	parameters = dict.get("parameters", [])
	presentations = dict.get("presentations", {})
	
func get_properties(value) -> Dictionary:
	for presentation in presentations:
		if evaluate_condition(presentation["condition"]):
			return presentation["result"]
	return default
func evaluate_condition(condition) -> bool:
	if condition["node_type"] == "conjunction":
		var sub_condition_evaluations = []
		if condition["operator"] == "AND":
			return sub_condition_evaluations.all(self.evaluate_condition)
		if condition["operator"] == "OR":
			return sub_condition_evaluations.any(self.evaluate_condition)
		else:
			print("Unknown operator: ", condition["operator"])
			return false
	if condition["node_type"] == "comparison":
		var p1 = evaluate_paramater(condition["param_1"])
		var p2 = evaluate_paramater(condition["param_2"])
		if condition["operator"] == ">":
			return p1 > p2
		if condition["operator"] == ">=":
			return p1 >= p2
		if condition["operator"] == "<":
			return p1 < p2
		if condition["operator"] == "<=":
			return p1 <= p2
		if condition["operator"] == "==":
			return p1 == p2
		if condition["operator"] == "!=":
			return p1 != p2
		else:
			print("Unknown operator: ", condition["operator"])
			return false
	else:
		print("Unknown condition node: ")
		return false
func evaluate_paramater(parameter):
	if parameter["type"] == "parameter":
		if parameters.has(parameter["value"]):
			return parameters[parameter["value"]]
		else:
			print("Unknown gene parameter: ", parameter["operator"])
			return 0
	if parameter["type"] == "constant":
		return parameter["value"]
	
