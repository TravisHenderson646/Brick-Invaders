class_name LevelCompleteUI
extends PanelContainer

@export var pups_list: Array[PackedScene]

@onready var tooltip: Label = %Tooltip
@onready var upgrades: HBoxContainer = %Upgrades
@onready var pups: Node = $Pups

const faster_balls_pup_scene = preload('res://faster_balls_pup.tscn') # THIS SHOULD BE ELSEWHERE TODO
const more_pups_pup_scene = preload('res://more_pups_pup.tscn')

signal next_level_pressed

func _ready() -> void:
	await get_tree().current_scene.ready
	get_tree().paused = true # REMOVE THIS AFTER TESTING
	EventBus.pup_focused.connect(_on_pup_focused)
	EventBus.pup_selected.connect(_on_pup_selected)
	tooltip.grab_focus()
	for child in upgrades.get_children():
		child.queue_free()
	pups.shuffle_pups_list()
	for x in range(Globals.pup_choices):
		var pup = pups.pick_a_pup()
		upgrades.add_child(pup)


func offer_new_pups() -> void:
	pass


func _on_pup_selected() -> void:
	tooltip.grab_focus()
	for child in upgrades.get_children():
		child.queue_free()

func _on_pup_focused(new_text) -> void:
	tooltip.text = new_text

func _on_next_level_button_pressed() -> void:
	get_tree().paused = false
	next_level_pressed.emit()

func _on_tooltip_focus_entered() -> void:
	tooltip.text = 'Level Completed!'
func _on_next_level_button_focus_entered() -> void:
	tooltip.text = 'Level Completed!!!!'
