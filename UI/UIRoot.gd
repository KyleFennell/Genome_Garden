extends Control

#@onready var LevelsButton = %LevelsButton
@onready var StoryButton = %StoryButton
#@onready var LevelsContainer = %LevelsContainer
@onready var MainMenu = %MainMenu
@onready var StoryContainer = %StoryContainer
@onready var InfoPanel = %InfoPanel
@onready var Tutorial = %Tutorial

func _ready():
	Globals.tutorial = Tutorial 
	#LevelsButton.button_up.connect(func(): 
		#MainMenu.hide()
		#LevelsContainer.show()
	#)
	StoryButton.button_up.connect(func():
		MainMenu.hide()
		StoryContainer.show()
		StoryContainer.start_story_mode()
	)
	StoryContainer.info_button_up.connect(func(): 
		print("show info panel")
		InfoPanel.show()
	)

func _input(event):
	if not event is InputEventMouseButton:
		return
	if event.button_index != MOUSE_BUTTON_LEFT:
		return
	if Globals.current_drag == null:
		print(event.position, ' ', event.global_position)
		return
	if not event.is_pressed():
		Globals.current_drag["previous_slot"].potential_drop(Globals.current_drag)
		Globals.current_drag = null
		#print("drop caught")
