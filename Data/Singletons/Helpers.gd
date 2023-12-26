extends Node

func slot_click_event(event, slot, slot_signal):
	#if not slot.has_item():
		#return
	if Settings.CLICK_CONTROLS:
		if event is InputEventMouseButton and event.button_mask == MOUSE_BUTTON_NONE and not event.pressed:
			slot_signal.emit(slot)
