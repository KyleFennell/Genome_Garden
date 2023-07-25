extends Container

@onready var ChildPreview = preload("res://UI/Preview/ChildPreview.tscn")

@onready var Parent1 = %ItemSlot
@onready var Parent2 = %ItemSlot2
@onready var ChildrenContainer = %ChildrenContainer

signal slot_clicked

func _ready():
	Parent1.connect("slot_contence_changed", on_parent_changed)
	Parent2.connect("slot_contence_changed", on_parent_changed)
	
	Parent1.connect("gui_input", Helpers.slot_click_event.bind(Parent1, slot_clicked))
	Parent2.connect("gui_input", Helpers.slot_click_event.bind(Parent2, slot_clicked))
	
func on_parent_changed() -> void:
	clear_previews()
	if Parent1.item != null and Parent2.item != null:
		update_children()
		
func on_gui_input(event: InputEvent, slot: ItemSlot) -> void:
	if Settings.CLICK_CONTROLS:
		if event is InputEventMouseButton and event.button_mask == MOUSE_BUTTON_NONE and not event.pressed:
			slot_clicked.emit(slot)

func update_children() -> void:
	# populates the possible children phenotypes
	var full_children = GeneHelpers.generate_children_with_percentages(Parent1.item, Parent2.item)
	var phenotypes = GeneHelpers.generate_phenotype_percents(full_children)
	for phenotype in phenotypes:
		var child_preview = ChildPreview.instantiate()
		ChildrenContainer.add_child(child_preview)
		child_preview.set_item(phenotypes[phenotype]["item"])
		child_preview.set_percent(phenotypes[phenotype]["chance"])

func clear_previews() -> void:
	for child in ChildrenContainer.get_children():
		child.queue_free()

func reset() -> void:
	Parent1.set_item(null)
	Parent2.set_item(null)
	clear_previews()

func can_quick_store_item(_item: Item) -> bool:
	return not Parent1.has_item() or not Parent2.has_item()
	
func quick_store_item(item: Item) -> void:
	if not Parent1.has_item():
		Parent1.set_item(item)
	elif not Parent2.has_item():
		Parent2.set_item(item)

func clear_parents_to_inventory() -> void:
	slot_clicked.emit(Parent1)
	Parent1.set_item(null)
	slot_clicked.emit(Parent2)
	Parent2.set_item(null)
