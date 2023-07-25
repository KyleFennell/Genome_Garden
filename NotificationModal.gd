extends MarginContainer

@onready var Heading = %Heading
@onready var ImageContainer = %ImageContainer
@onready var Message = %Message
const ItemDisplay = preload("res://UI/Common/ItemDisplay.tscn")

func _ready():
	Events.show_modal.connect(show_modal)
	position = get_home()

func update_info(info: Dictionary) -> void:
	
	Heading.text = info.get("heading", "")
	Message.text = info.get("message", "")

	for child in ImageContainer.get_children():
		child.queue_free()
	
	if info.has("image_node"):
		ImageContainer.add_child(info["image_node"])
	elif info.has("item"):
		var image_node = ItemDisplay.instantiate()
		ImageContainer.add_child(image_node)
		image_node.set_item(info["item"])

func show_modal(info: Dictionary):
	
	update_info(info)
	
	custom_minimum_size.x = get_window().size.x * (0.75)
	position = get_home()
	
	hide_empty_fields()
	animate_modal()
	
func hide_empty_fields() -> void:
	
	if Message.text == "":
		Message.hide()
	else:
		Message.show()
	if ImageContainer.get_child_count() == 0:
		ImageContainer.hide()
	else:
		ImageContainer.show()

func animate_modal() -> void:
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(position.x, 1), 1)
	tween.tween_interval(2)
	tween.tween_property(self, "position", get_home(), 1)

func get_home():
	return Vector2(position.x, -size.y-5)
