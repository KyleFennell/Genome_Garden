extends ItemSlot

func _ready():
	if item == null:
		ItemDisplay.hide()

func _can_drop_data(_at_position: Vector2, _data: Variant) -> bool:
	return true

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	item = data["item"]
	data["previous_slot"].set_item(null)

func has_item() -> bool:
	return false
