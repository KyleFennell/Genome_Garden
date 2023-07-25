extends MarginContainer

@onready var Goals = %Goals
@onready var Breed = %Breed
@onready var Inventory = %Inventory
@onready var CompleteContainer = %CompleteContainer
@onready var Preview = %Preview
@onready var Identify = %Identify
@onready var Mutations = %Mutations
@onready var Tabs = %Tabs

var loaded_level_name = null
var previous_tab = 1

signal level_complete
signal back_to_menu
signal slot_clicked

#var drag_data = null

func _ready():
	Goals.connect("all_goals_complete", on_all_goals_complete)
	CompleteContainer.connect("confirm_level_complete", on_confirm_level_complete)
	for child in Tabs.get_children():
		if child.has_signal("slot_clicked"):
			child.connect("slot_clicked", on_functional_slot_clicked)
	Tabs.connect("tab_changed", on_tab_changed)

func load_level(level_name: String):
	loaded_level_name = level_name
	Goals.reset()
	for child in Tabs.get_children():
		child.reset()
	Tabs.current_tab = 0
	Globals.current_level = level_name
	var level = Database.Levels[level_name]
	Goals.load_goals(level.goal)
	Inventory.load_inventory(level.starting_inventory)
	Mutations.load_hidden_combinations(level.hidden_combinations)

func on_functional_slot_clicked(slot: ItemSlot):
	if Inventory.can_quick_store_item(slot.item):
		Inventory.quick_store_item(slot.item)
		slot.set_item(null)

func on_inventory_slot_clicked(slot: ItemSlot):
	var current_tab = Tabs.get_current_tab_control()
	if current_tab.has("can_quick_store_item") and \
			current_tab.can_quick_store_item(slot.item):
		current_tab.quick_store_item(slot.item)
		slot.set_item(null)

func on_tab_changed(tab):
	if self.previous_tab == 1:
		Preview.clear_parents_to_inventory()
	self.previous_tab = tab

func on_all_goals_complete():
	CompleteContainer.show()
	level_complete.emit(loaded_level_name)

func on_confirm_level_complete():
	CompleteContainer.hide()
	loaded_level_name = null
	back_to_menu.emit()

func reload():
	load_level(loaded_level_name)
