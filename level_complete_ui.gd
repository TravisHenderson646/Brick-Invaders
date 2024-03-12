class_name LevelCompleteUI
extends PanelContainer

@onready var tooltip: Label = %Tooltip

signal next_level_pressed

func _ready() -> void:
	tooltip.grab_focus()
	get_tree().paused = true


func _on_next_level_button_pressed() -> void:
	next_level_pressed.emit()
	visible = false
	get_tree().paused = false
	get_tree().change_scene_to_file(Globals.levels['level1'])


# TODO these 3 need to be condensed to one func that uses resourses or idk
# I think the script that calls an instance of this to display should generate the random rewards and insert them
func _on_upgrade_1_focus_entered() -> void:
	tooltip.text = 'Upgrade 1'
func _on_upgrade_2_focus_entered() -> void:
	tooltip.text = 'Second upgrade'
func _on_upgrade_3_focus_entered() -> void:
	tooltip.text = '3'
func _on_tooltip_focus_entered() -> void:
	tooltip.text = 'Level Completed!'
func _on_next_level_button_focus_entered() -> void:
	tooltip.text = 'Level Completed!!!!'
