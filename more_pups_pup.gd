extends Button

@export_multiline var custom_tooltip_text: String


func _on_pressed() -> void:
	EventBus.pup_selected.emit()
	Globals.pup_choices += 1
	#get_tree().reload_current_scene() for testing


func _on_focus_entered() -> void:
	EventBus.pup_focused.emit(custom_tooltip_text)
