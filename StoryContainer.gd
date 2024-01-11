extends VBoxContainer

@onready var HeaderBar = %HeaderBar
@onready var StoryUI = %StoryUI

signal info_button_up

func _ready():
	HeaderBar.connect("info_button_up", func(): info_button_up.emit())

func start_story_mode():
	StoryUI.start_story_mode()
