extends Control

@onready var itemList = %ItemList
@onready var ItemSlot = preload("res://UI/Common/ItemSlot.tscn")
@onready var DeleteSlot = preload("res://UI/Common/DeleteSlot.tscn")
var INVENTORY_SIZE: int = 11
@export var CONTAINS_DELETE: bool = true

signal slot_clicked

func _ready():
	for i in INVENTORY_SIZE:
		var slot_instance = ItemSlot.instantiate()
		itemList.add_child(slot_instance)
		slot_instance.connect("gui_input", Helpers.slot_click_event.bind(slot_instance, slot_clicked))
	if CONTAINS_DELETE:
		var delete_slot = DeleteSlot.instantiate()
		itemList.add_child(delete_slot)

func on_gui_input(event: InputEvent, slot: ItemSlot, slot_signal: Signal) -> void:
	if Settings.CLICK_CONTROLS:
		if event is InputEventMouseButton and event.button_mask == MOUSE_BUTTON_NONE and not event.pressed:
			slot_signal.emit(slot)

func load_inventory(items: Array) -> void:
	if items.size() < INVENTORY_SIZE:
		for i in items.size():
			items[i].is_starting_item = true
			var inventory_slot = itemList.get_child(i)
			inventory_slot.set_item(items[i])
	else:
		print("ERROR: too many items for inventory! InventorySize: ", INVENTORY_SIZE, " items: ", items.size())

func reset() -> void:
	itemList.get_children().all(func(child): child.set_item(null))

func delete_item(item: Item) -> bool:
	for child in itemList.get_children():
		if child.has_item() and item.equals(child.item, true):
			child.set_item(null)
			return true
	return false

func can_quick_store_item(_item: Item) -> bool:
	for child in itemList.get_children():
		if not child.has_item():
			return true
	return false
	
func quick_store_item(item: Item) -> void:
	for child in itemList.get_children():
		if not child.has_item():
			child.set_item(item)
			return
