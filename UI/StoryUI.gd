extends MarginContainer

@onready var Goals = %Goals
@onready var Breed = %Breed
@onready var Inventory = %Inventory
@onready var Preview = %Preview
@onready var Identify = %Identify
@onready var Contracts = %Contracts
@onready var Tabs = %Tabs

var loaded_level_name = null
var previous_tab = 1

signal level_complete
signal back_to_menu
signal slot_clicked

#var drag_data = null

func _ready():
	for child in Tabs.get_children():
		if child.has_signal("slot_clicked"):
			child.connect("slot_clicked", on_functional_slot_clicked)
	Tabs.connect("tab_changed", on_tab_changed)
	Inventory.connect("slot_clicked", on_inventory_slot_clicked)

func start_story_mode():
	Database.Levels["Story"] = Level.new({"name": "Story", "genome": ["colour_1"]})
	Globals.current_level = "Story"
	var contract_values: Array[Contract]
	contract_values.assign(Database.Contracts.values())
	Contracts.load_contracts(contract_values)
	Contracts.show_contract("pea_breeding")
	Inventory.load_inventory([
		Item.new({
			"genes": {
				"colour_1": "GG"
			}
		}),
		Item.new({
			"genes": {
				"colour_1": "GG"
			}
		})
	])
	
func on_functional_slot_clicked(slot: ItemSlot):
	if slot.has_item():
		if Inventory.can_quick_store_item(slot.item):
			Inventory.quick_store_item(slot.item)
			slot.set_item(null)

func on_inventory_slot_clicked(slot: ItemSlot):
	var current_tab = Tabs.get_current_tab_control()
	if current_tab.has_method("can_quick_store_item") and \
			current_tab.can_quick_store_item(slot.item):
		current_tab.quick_store_item(slot.item)
		slot.set_item(null)

func on_tab_changed(tab):
	if self.previous_tab == 1:
		Preview.clear_parents_to_inventory()
	self.previous_tab = tab

func on_goal_auto_fill(goal_slot: GoalSlot):
	if (Inventory.delete_item(goal_slot.target_item)):
		goal_slot.set_item(goal_slot.target_item)

