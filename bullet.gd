class_name Bullet
extends Area2D

@export var SPEED = .3

var direction = Vector2(1, 0)
var velocity = Vector2.ZERO
var tick_counter := -1

func _physics_process(_delta: float) -> void:
	tick_counter += 1
	velocity = direction.normalized() * SPEED

	position += velocity

	if tick_counter >= 3600:
		queue_free()


func die():
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Ball:
		EventBus.update_score.emit(10)
		die()
