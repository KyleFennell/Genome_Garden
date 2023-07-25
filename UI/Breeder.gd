extends VBoxContainer

const BreedingRow = preload("res://UI/Breeding_Row/Breeding_Row.tscn")
var breeder_count = 2

func _ready():
	for i in breeder_count:
		add_child(BreedingRow.instantiate())

func can_quick_store_item(item: Item) -> bool:
	return get_children().any(func(c): c.can_quick_store_item(item))
	
func quick_store_item(item: Item) -> void:
	for child in get_children():
		if child.can_quick_store_item(item):
			child.quick_store_item(item)
			return

func reset():
	for child in get_children():
		child.reset()
