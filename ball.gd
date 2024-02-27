class_name Ball
extends CharacterBody2D


@export var SPEED = 1.5

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var direction = Vector2(1, 1)

func _physics_process(delta: float) -> void:
	velocity = direction.normalized() * SPEED
	
	var collision_info = move_and_collide(velocity)
	if not collision_info:
		return
	var collider = collision_info.get_collider()
	direction = direction.bounce(collision_info.get_normal())
	if collider.has_method('get_hit'):
		collider.get_hit()
		


func _on_paddle_detector_body_entered(body: Node2D) -> void:
	if not body is Paddle:
		return
	if velocity.y > 0:
		print('test')
		direction.y = -direction.y
		
