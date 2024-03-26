class_name LevelCompleteUI
extends PanelContainer

@export var pups_list: Array[Pup]

@onready var tooltip:Label = %Tooltip
@onready var upgrades:HBoxContainer = %Upgrades

const faster_balls_pup_scene = preload('res://faster_balls_pup.tscn') # THIS SHOULD BE ELSEWHERE TODO
const more_pups_pup_scene = preload('res://more_pups_pup.tscn')
const TEST_PUP = preload('res://test_pup.tres')

signal next_level_pressed

func _ready() -> void:
	pass

func setup() -> void:
	await get_tree().create_timer(1).timeout
	get_tree().paused = true # REMOVE THIS AFTER TESTING
	tooltip.grab_focus()
	for child in upgrades.get_children():
		child.queue_free()
	for x in range(Globals.num_pup_choices):
		var new_pup_button:PupButton = preload('res://pup_button.tscn').instantiate()
		upgrades.add_child(new_pup_button)
		new_pup_button.pup = pups_list.pop_front()
		pups_list.push_back(new_pup_button.pup)
		new_pup_button.pup_selected.connect(_on_pup_selected)
		new_pup_button.request_tooltip.connect(_on_request_tooltip)


func _on_request_tooltip(new_text) -> void:
	tooltip.text = new_text

func offer_new_pups() -> void:
	pass


func _on_pup_selected() -> void:
	tooltip.grab_focus()
	for child in upgrades.get_children():
		child.queue_free()

func _on_next_level_button_pressed() -> void:
	get_tree().paused = false
	next_level_pressed.emit()

func _on_tooltip_focus_entered() -> void:
	tooltip.text = 'Level Completed!'
func _on_next_level_button_focus_entered() -> void:
	tooltip.text = 'Level Completed!!!!'
