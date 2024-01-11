extends Node

func element_clicked_event(event, element, sig):
	#if not slot.has_item():
		#return
	if Settings.CLICK_CONTROLS:
		if event is InputEventMouseButton and event.button_mask == MOUSE_BUTTON_NONE and not event.pressed:
			sig.emit(element)

func clicked_event(event, element, sig):
	if Settings.CLICK_CONTROLS:
		if event is InputEventMouseButton and event.button_mask == MOUSE_BUTTON_NONE and not event.pressed:
			sig.emit()
