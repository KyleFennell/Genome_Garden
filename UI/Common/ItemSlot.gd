extends Container
class_name ItemSlot

@onready var BackgroundTexture = %BackgroundTexture
@onready var ItemDisplay = %ItemDisplay

@export var dragable: bool = true
@export var dropable: bool = true

signal slot_contence_changed
var item = null

func _ready():
	if item == null:
		ItemDisplay.hide()

func set_item(_item: Item) -> void:
	self.item = _item
	ItemDisplay.set_item(item)
	emit_signal("slot_contence_changed")

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if item != null:
		return data["previous_slot"].dropable
	return dropable

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if item != null:
		if data["previous_slot"].dropable:
			data["previous_slot"].set_item(item)
			Globals.current_drag = null
		else:
			return
	else:	
		data["previous_slot"].set_item(null)
		Globals.current_drag = null
		
	set_item(data.item)

func _get_drag_data(_at_position: Vector2) -> Variant:
	if dragable and item != null:
		
		var drag_preview = TextureRect.new()
		drag_preview.texture = ItemDisplay.MainTexture.texture
		drag_preview.position.x = -(drag_preview.texture.get_width()/2)
		drag_preview.position.y = -(drag_preview.texture.get_height()/2)
		
		var container = Container.new()
		container.add_child(drag_preview)
		
		set_drag_preview(container)
		ItemDisplay.hide()
		
		var drag_data = {"item": item, "previous_slot": self}
		Globals.current_drag = drag_data
	
		return drag_data
	
	return null

func has_item() -> bool:
	return item != null
