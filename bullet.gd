class_name Bullet
extends Area2D

@export var SPEED = .3

var direction = Vector2(.1, 1)
var velocity = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	velocity = direction.normalized() * SPEED
	
	position += velocity


func die():
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Ball:
		die()
