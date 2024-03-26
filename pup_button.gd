extends Button
class_name PupButton

signal request_tooltip(tester)
signal pup_selected

var pup: Pup : set = _set_pup

# could set up the icon and maybe even connect the activation function?
func _set_pup(value: Pup) -> void:
	pup = value
	icon = value.icon

func _on_focus_entered() -> void:
	request_tooltip.emit(pup.description)


func _on_pressed() -> void:
	pup_selected.emit()
	pup.activate()

