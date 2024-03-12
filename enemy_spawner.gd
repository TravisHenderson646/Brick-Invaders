extends Node2D

@onready var nw_spawn: Marker2D = $NWSpawn
@onready var ne_spawn: Marker2D = $NESpawn

const bullet_scene = preload('res://bullet.tscn')
var spawn_points: Array[Marker2D]
var tick_counter := -1
var left := true

func _ready() -> void:
	for child in get_children():
		spawn_points.append(child)

func _process(_delta: float) -> void:
	tick_counter += 1
	if tick_counter % 60 == 0:
		left = not left
		var new_bullet = bullet_scene.instantiate()
		if left:
			new_bullet.position = nw_spawn.position
			new_bullet.direction = Vector2(1, 2)
		else:
			new_bullet.position = ne_spawn.position
			new_bullet.direction = Vector2(-1, 2)
		get_tree().root.add_child(new_bullet)

