class_name Brick
extends StaticBody2D

@onready var polygon_2d: Polygon2D = $CollisionShape2D/Polygon2D
@onready var polygon_2d_2: Polygon2D = $CollisionShape2D/Polygon2D2

signal brick_died

var hp = 2

func _ready() -> void:
	modulate = Color(modulate.r + randf() - 0.5, modulate.g + randf() - 0.5, modulate.b + randf() - 0.5)

func _get_hit():
	hp -= 1
	polygon_2d.visible = false
	polygon_2d_2.visible = true
	if hp <= 0:
		die()


func die():
	Globals.score += 100
	queue_free()
	brick_died.emit()
