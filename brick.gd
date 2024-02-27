class_name Brick
extends StaticBody2D

var hp = 2

func _ready() -> void:
	modulate = Color(modulate.r + randf() - 0.5, modulate.g + randf() - 0.5, modulate.b + randf() - 0.5)

func get_hit():
	hp -= 1
	if hp <= 0:
		die()

func die():
	queue_free()
