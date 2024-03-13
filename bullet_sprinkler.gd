class_name BulletSprinkler
extends Node2D

@export var radial_delta = PI / 13 + PI / 2
@export var ticks_per_spawn := 5
@export var bullet_scene: PackedScene

signal bullet_set_finished

var tick_counter := -1
var bullet_counter := -1
var direction := Vector2.ZERO
var speed := 0.0

func _ready() -> void:
	position = Vector2(144/2, 20)


func _physics_process(_delta: float) -> void:
	tick_counter += 1
	if tick_counter == 600:
		bullet_set_finished.emit()
		return
	position += direction.normalized() * speed
	if tick_counter % ticks_per_spawn == 0:
		bullet_counter += 1
		var bullet = bullet_scene.instantiate()
		get_tree().current_scene.add_child(bullet)
		bullet.position = global_position
		bullet.direction = bullet.direction.rotated(radial_delta * bullet_counter)


