class_name Paddle
extends CharacterBody2D

@export var MAX_SPEED := 3.0
@export var ACCELERATION := 0.3

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var ball_on_deck: Polygon2D = $BallOnDeck


func _ready() -> void:
	create_ball_spawn_timer()

func create_ball_spawn_timer() -> void:
	var ball_spawn_timer = Timer.new()
	ball_spawn_timer.process_callback = Timer.TIMER_PROCESS_PHYSICS
	ball_spawn_timer.wait_time = Globals.new_ball_delay
	ball_spawn_timer.timeout.connect(_add_ready_ball)
	add_child(ball_spawn_timer)
	ball_spawn_timer.start()


func _physics_process(_delta: float) -> void:
	var direction := 0
	if Input.is_action_pressed('right'):
		direction = 1
	if Input.is_action_pressed('left'):
		direction -= 1
	if direction:
		velocity.x = move_toward(velocity.x, direction * MAX_SPEED, ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION)

	handle_collision()

func handle_collision() -> void:
	var collision_info = move_and_collide(velocity)
	if not collision_info:
		return
	var collider = collision_info.get_collider()
	if collider.name == 'RightWall' or collider.name == 'LeftWall':
		velocity.x = 0


func get_hit() -> void:
	Globals.health -= 1
	EventBus.updated_health.emit()
	if Globals.health <= 0:
		die()


func die() -> void:
	get_tree().paused = true


func _add_ready_ball() -> void:
	if Globals.balls_ready < Globals.max_balls:
		Globals.balls_ready += 1

func _on_heart_area_entered(area: Area2D) -> void:
	if area is Bullet or area is GravityBullet:
		get_hit()
		if Globals.health > 0:
			area.queue_free()
