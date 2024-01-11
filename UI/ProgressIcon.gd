extends Container

@onready var TextureDisplay = %TextureDisplay
@onready var Bar = %Bar

signal clicked

func _ready():
	self.connect("gui_input", Helpers.clicked_event.bind(self, clicked))

func set_icon(icon: Texture):
	self.TextureDisplay.texture = icon

func get_icon():
	return TextureDisplay

func set_progress(value: int):
	self.Bar.value = clamp(value, 0, 100)
