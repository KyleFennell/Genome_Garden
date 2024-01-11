extends MarginContainer

@onready var NameLabel = %NameLabel
@onready var Bar = %Bar

signal clicked

func _ready():
	self.connect("gui_input", Helpers.clicked_event.bind(self, clicked))

func set_label(name: String):
	self.NameLabel.text = name
	
func set_progress(value: int):
	self.Bar.value = clamp(value, 0, 100)
