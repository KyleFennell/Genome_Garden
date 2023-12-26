extends VBoxContainer

@onready var HeaderBar = %HeaderBar
@onready var LevelSelectUI = %SelectUI
@onready var SelectUI = %SelectUI
@onready var LevelUI = %StoryUI

func _ready():
	HeaderBar.connect("menu_button_up", on_back_to_menu)
	HeaderBar.connect("reset_button_up", on_reset_button)
	LevelSelectUI.connect("level_button_pressed", on_level_button_pressed)

func on_level_button_pressed(level_name):
	HeaderBar.HeaderLabel.text = level_name
	LevelUI.load_level(level_name)
	LevelSelectUI.hide()
	LevelUI.show()
	
func on_level_complete(level_name):
	LevelSelectUI.complete_level(level_name)

func on_back_to_menu():
	HeaderBar.HeaderLabel.text = "Levels"
	LevelSelectUI.show()
	LevelUI.hide()

func on_reset_button():
	LevelUI.reload()
