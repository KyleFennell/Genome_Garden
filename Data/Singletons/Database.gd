extends Node

var Levels = {}
var Genes = {}
var Interactions = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	load_data("Genes", Gene)
	load_data("Interactions", Interaction)
	load_data("Levels", Level)

func load_data(data_name, resource_type):
	var file = FileAccess.open("res://Data/DataFiles/"+data_name+".json", FileAccess.READ)
	var resources = JSON.parse_string(file.get_as_text())
	for res in resources:
		var new_resource = resource_type.new(res)
		self[data_name][res["name"]] = new_resource
