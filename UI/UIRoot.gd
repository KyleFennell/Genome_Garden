extends Control

@onready var HeaderBar = %HeaderBar
@onready var InfoPannel = %InfoPannel
@onready var LevelUI = %LevelUI
@onready var LevelSelectUI = %SelectUI

func _ready():
	HeaderBar.connect("menu_button_up", on_back_to_menu)
	HeaderBar.connect("reset_button_up", on_reset_button)
	HeaderBar.connect("info_button_up", on_info_button)
	LevelSelectUI.connect("level_button_pressed", on_level_button_pressed)
	LevelUI.connect("back_to_menu", on_back_to_menu)
	LevelUI.connect("level_complete", on_level_complete)
	var panel: Panel = %Panel
	print('\n'.join(panel.get_property_list()))
	print(panel.theme)

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

func on_info_button():
	InfoPannel.show()

func _input(event):
	if not event is InputEventMouseButton:
		return
	if event.button_index != MOUSE_BUTTON_LEFT:
		return
	if Globals.current_drag == null:
		return
	if not event.is_pressed():
		Globals.current_drag["previous_slot"].potential_drop(Globals.current_drag)
		Globals.current_drag = null
		print("drop caught")
