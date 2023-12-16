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
	print(data_name)
	var my_csharp_script = preload("res://Data/Singletons/YmlToJson.cs")
	var my_csharp_node = my_csharp_script.new()
	var resources = JSON.parse_string(my_csharp_node.Convert("res://Data/DataFiles/"+data_name+".yml"))
	for res in resources:
		var new_resource = resource_type.new(res)
		self[data_name][res["name"]] = new_resource
