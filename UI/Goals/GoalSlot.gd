extends ItemSlot

var target_item = null
var target_quantity = 1
var current_quantity = 0
@onready var incomplete_texture = preload("res://Resources/UI/Goal_Slot.png")
@onready var complete_texture = preload("res://Resources/UI/Goal_Slot_Complete.png")
@onready var TargetDisplay = %TargetDisplay
@onready var CompleteLabel = %CompleteLabel

signal goal_complete

func set_goal(goal_item: GoalItem) -> void:
	self.target_item = goal_item
	self.target_quantity = goal_item.target_quantity
	TargetDisplay.set_item(target_item)
	update_quantity_label()

func set_item(_item: Item) -> void:
	if item != null:
		update_quantity_label()
		if current_quantity >= target_quantity:
			BackgroundTexture.texture = complete_texture
			super.set_item(item)
			goal_complete.emit()
		else:
			BackgroundTexture.texture = incomplete_texture
	
func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if data["item"].is_starting_item:
		return false
	return target_item.equals(data.item)	

func update_quantity_label() -> void:
	CompleteLabel.text = "/".join([str(current_quantity), str(target_quantity)])

func _drop_data(at_position: Vector2, data: Variant) -> void:
	current_quantity += 1
	super._drop_data(at_position, data)

func _get_drag_data(at_position: Vector2) -> Variant:
	current_quantity -= 1
	update_quantity_label()
	return super._get_drag_data(at_position)
