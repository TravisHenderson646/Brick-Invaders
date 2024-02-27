class_name Paddle
extends CharacterBody2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var MAX_SPEED := 3.0
@export var ACCELERATION := 0.3


func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * MAX_SPEED, ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION)
	var collision_info = move_and_collide(velocity)
	#if not collision_info:
		#return
