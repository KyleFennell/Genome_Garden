extends Container

@onready var ItemDisplay = %ItemDisplay
@onready var Bar = %Bar

signal clicked

func _ready():
	self.connect("gui_input", Helpers.clicked_event.bind(self, clicked))

func set_item(item: Item):
	self.ItemDisplay.set_item(item)
	
func set_progress(value: int):
	self.Bar.value = clamp(value, 0, 100)
