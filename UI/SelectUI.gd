extends ScrollContainer

@onready var LevelContainer = %LevelContainer
@onready var MidStyledButton = preload("res://UI/MidStyledButton.tscn")
@onready var LevelCompleteButtonTheme = preload("res://Panel_Green.tres") 

signal level_button_pressed
var complete_levels = []

func _ready():
	for level in Database.Levels:
		var level_button: Button = MidStyledButton.instantiate()
		level_button.connect("button_up", get_level_closure(level))
		
		level_button.text = level
		LevelContainer.add_child(level_button)

func get_level_closure(level):
	return func(): level_button_pressed.emit(level)

func complete_level(level_name):
	complete_levels.append(level_name)
	for child in LevelContainer.get_children():
		if child.text == level_name:
			child.add_theme_stylebox_override("normal", LevelCompleteButtonTheme)
