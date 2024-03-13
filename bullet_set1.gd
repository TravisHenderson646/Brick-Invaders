extends Node2D

@onready var nw_spawn: Marker2D = $NWSpawn
@onready var ne_spawn: Marker2D = $NESpawn

signal bullet_set_finished

const bullet_scene = preload('res://bullet.tscn')
var spawn_points: Array[Marker2D]
var tick_counter := -1

func _ready() -> void:
	for child in get_children():
		spawn_points.append(child)

func _process(_delta: float) -> void:
	tick_counter += 1
	if tick_counter == 600:
		bullet_set_finished.emit()
		return
	if tick_counter % 60 == 0:
		spawn_bullet(nw_spawn.position, Vector2(0, 1))

func spawn_bullet(pos, dir) -> void:
	var new_bullet = bullet_scene.instantiate()
	new_bullet.position = pos
	new_bullet.direction = dir
	get_tree().current_scene.add_child(new_bullet)


