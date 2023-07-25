extends PanelContainer

@onready var itemList = %ItemList
@onready var GoalSlot = preload("res://UI/Goals/GoalSlot.tscn")

signal all_goals_complete

var INVENTORY_SIZE = 8

func _ready():
	reset()

func load_goals(items: Array):
	for i in items:
		var slot_instance = GoalSlot.instantiate()
		itemList.add_child(slot_instance)
		slot_instance.connect("goal_complete", on_goal_complete)
		slot_instance.set_goal(i)

func on_goal_complete():
	for child in itemList.get_children():
		if child.item == null:
			return
	level_complete()

func level_complete():
	all_goals_complete.emit()

func reset():
	for child in itemList.get_children():
		child.queue_free()
