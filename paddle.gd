class_name Paddle
extends CharacterBody2D

@export var MAX_SPEED := 3.0
@export var ACCELERATION := 0.3

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


func _physics_process(_delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * MAX_SPEED, ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION)
	var collision_info = move_and_collide(velocity)
	if not collision_info:
		return
	var collider = collision_info.get_collider()
	if collider.name == 'RightWall' or collider.name == 'LeftWall':
		velocity.x = 0


func get_hit():
	print('you got hit')


func _on_heart_area_entered(area: Area2D) -> void:
	if area is Bullet:
		get_hit()
		area.queue_free()
		
