extends Resource
class_name SpeciesModule

var name: String
var kind: String
var parent: SpeciesModule
var params: Dictionary
var node: Node

func _init(data: Dictionary, modules: Array):
	self.name = data.get("name")
	self.kind = data.get("kind")
	if data.has("parent"):
		self.parent = modules.filter(func(m): return m.name == data.get("parent"))[0]

func create_on(root: Node):
	if parent != null:
		parent.node.add_child(node)
	else:
		root.add_child(node)
		print("child added", root.get_children())

func process_attributes(dict: Dictionary):
	pass
