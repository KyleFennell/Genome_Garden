extends Container

@onready var InputSlot = %InputSlot
@onready var ProgressArrow = %ProgressArrow
@onready var OutputSlot = %OutputSlot

signal slot_clicked

func _ready():
	InputSlot.connect("slot_contence_changed", on_input_item_changed)
	InputSlot.connect("gui_input", Helpers.element_clicked_event.bind(InputSlot, slot_clicked))
	OutputSlot.connect("slot_contence_changed", on_output_item_changed)
	OutputSlot.connect("gui_input", Helpers.element_clicked_event.bind(OutputSlot, slot_clicked))
	ProgressArrow.connect("timeout", on_identifying_timer_finished)
	
func on_input_item_changed() -> void:
	if InputSlot.has_item() and not OutputSlot.has_item():
		start_identifying()
	else:
		ProgressArrow.set_percent(0)
		cancel_identifying()

func on_output_item_changed() -> void:
	if not OutputSlot.has_item():
		on_input_item_changed()
	else:
		cancel_identifying()

func start_identifying() -> void:
	ProgressArrow.start()

func cancel_identifying() -> void:
	ProgressArrow.stop()
	
func on_identifying_timer_finished() -> void:
	complete_identifying()

func complete_identifying() -> void:
	if InputSlot.has_item():
		InputSlot.item.identify()
		OutputSlot.set_item(InputSlot.item)
		InputSlot.set_item(null)

func output_full() -> bool:
	return OutputSlot.has_item()

func can_quick_store_item(item: Item) -> bool:
	if InputSlot.has_item():
		return false
	return item != null and not item.identified

func quick_store_item(item: Item) -> void:
	InputSlot.set_item(item)

func reset() -> void:
	InputSlot.set_item(null)
	OutputSlot.set_item(null)
