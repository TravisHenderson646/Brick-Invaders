extends Node

var current_pup = 0

# just delete them after the player picks them
@export var master_pups_list_test: Array[PackedScene]
var master_pups_list = [
	preload('res://more_pups_pup.tscn'),
	preload('res://faster_balls_pup.tscn'),
]

var pups_list: Array
var current_pups := []

func _ready() -> void:
	pups_list = master_pups_list


func shuffle_pups_list() -> void:
	pups_list.shuffle()

func pick_a_pup() -> Button:
	var pup = pups_list[0].instantiate()
	return pup

