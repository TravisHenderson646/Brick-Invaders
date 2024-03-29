class_name Bullet
extends Area2D

@export var SPEED = .8

var direction = Vector2(1, 0)
var velocity = Vector2.ZERO
var tick_counter := -1

func _physics_process(_delta: float) -> void:
	tick_counter += 1
	velocity = direction.normalized() * SPEED

	position += velocity

	if tick_counter >= 360:
		queue_free()


func die():
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Ball:
		Globals.score += 1
		die()
