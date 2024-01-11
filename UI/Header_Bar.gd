extends Control

@onready var reset_button = %ResetButton
@onready var info_button = %InfoButton
@onready var HeaderLabel = %Label
@onready var menu_button = %MenuButton

signal reset_button_up
signal menu_button_up
signal info_button_up

# Called when the node enters the scene tree for the first time.
func _ready():
	reset_button.connect("button_up", on_reset_button_up)
	menu_button.connect("button_up", on_menu_button_up)
	info_button.connect("button_up", on_info_button_up)

func on_reset_button_up():
	reset_button_up.emit()

func on_menu_button_up():
	menu_button_up.emit()

func on_info_button_up():
	print("info_button_up")
	info_button_up.emit()
