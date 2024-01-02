extends Node
class_name SpeciesModules


static func get_module(module_name: String):
	match module_name:
		"Texture": return preload("res://Data/DataClasses/SpeciesModules/Texture.gd")
		"AtlasTexture": return preload("res://Data/DataClasses/SpeciesModules/AtlasTexture.gd")
