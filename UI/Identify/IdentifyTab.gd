extends Container

@onready var Row1 = %IdentifierRow
@onready var Row2 = %IdentifierRow2
@onready var Row3 = %IdentifierRow3

signal slot_clicked

func _ready():
	Row1.connect("slot_clicked", func(slot): slot_clicked.emit(slot))
	Row2.connect("slot_clicked", func(slot): slot_clicked.emit(slot))
	Row3.connect("slot_clicked", func(slot): slot_clicked.emit(slot))

func on_row_slot_clicked(slot):
	slot_clicked.emit(slot)

func can_quick_store_item(item):
	return Row1.can_quick_store_item(item) or Row2.can_quick_store_item(item) or Row3.can_quick_store_item(item)

func quick_store_item(item):
	if Row1.can_quick_store_item(item) and not Row1.output_full():
		Row1.quick_store_item(item)
	elif Row2.can_quick_store_item(item) and not Row2.output_full():
		Row2.quick_store_item(item)
	elif Row3.can_quick_store_item(item) and not Row3.output_full():
		Row3.quick_store_item(item)
	elif Row1.can_quick_store_item(item):
		Row1.quick_store_item(item)
	elif Row2.can_quick_store_item(item):
		Row2.quick_store_item(item)
	elif Row3.can_quick_store_item(item):
		Row3.quick_store_item(item)

func reset():
	Row1.reset()
	Row2.reset()
	Row3.reset()
