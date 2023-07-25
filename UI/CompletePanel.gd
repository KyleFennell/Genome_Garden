extends Container

@onready var OkButton = %OkButton
@onready var BackButton = %BackButton
signal confirm_level_complete

func _ready():
	OkButton.connect("button_up", on_ok_button_up)
	BackButton.connect("button_up", on_back_button_up)

func on_ok_button_up():
	confirm_level_complete.emit()

func on_back_button_up():
	self.hide()
