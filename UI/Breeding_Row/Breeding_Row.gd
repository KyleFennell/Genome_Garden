extends PanelContainer

@onready var Input1 = %Input1
@onready var Input2 = %Input2
@onready var Output = %Output
@onready var ProgressArrow = %ProgressArrow
@export var BREED_TIME = 2

signal slot_clicked

func _ready():
	Input1.connect("slot_contence_changed", on_input_item_changed)
	Input2.connect("slot_contence_changed", on_input_item_changed)
	Output.connect("slot_contence_changed", on_output_item_changed)
	
	Input1.connect("gui_input", Helpers.slot_click_event.bind(Input1, slot_clicked))
	Input2.connect("gui_input", Helpers.slot_click_event.bind(Input2, slot_clicked))
	Output.connect("gui_input", Helpers.slot_click_event.bind(Output, slot_clicked))
	
	ProgressArrow.TIME = BREED_TIME
	ProgressArrow.connect("timeout", on_breeding_timer_finished)

func set_progress(p: int) -> void:
	ProgressArrow.set_percent(p)

func on_input_item_changed() -> void:
	if Input1.has_item() and Input2.has_item() and not Output.has_item():
		start_breeding()
	else:
		ProgressArrow.set_percent(0)
		cancel_breeding()

func on_output_item_changed() -> void:
	if not Output.has_item():
		on_input_item_changed()
	else:
		cancel_breeding()

func start_breeding() -> void:
	ProgressArrow.start()

func cancel_breeding() -> void:
	ProgressArrow.stop()
	
func on_breeding_timer_finished() -> void:
	complete_breeding()

func complete_breeding():
	if Input1.has_item() and Input2.has_item():
		var child = GeneHelpers.generate_child(Input1.item, Input2.item)
		Output.set_item(child)

func reset() -> void:
	Input1.set_item(null)
	Input2.set_item(null)
	Output.set_item(null)
	
func can_quick_store_item(_item: Item) -> bool:
	return (not Input1.has_item()) or (not Input2.has_item())
	
func quick_store_item(item: Item) -> void:
	if not Input1.has_item():
		Input1.set_item(item)
	elif not Input2.has_item():
		Input2.set_item(item)
