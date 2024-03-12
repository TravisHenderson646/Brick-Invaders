extends Node2D

@export var next_level: PackedScene

@onready var paddle: Paddle = $Paddle

const level_complete_ui = preload('res://level_complete_ui.tscn')
const ball_scene = preload('res://ball.tscn')
const brick_scene = preload('res://brick.tscn')
const sprinkler_scene = preload('res://bullet_sprinkler.tscn')

var tick_counter := -1
var max_balls := 3
var ball_respawn_rate := 1200
var sprinkler_respawn_rate := 1200
var sprinkler_respawn_rate_default := 1200
var levels_cleared := 0
var brick_check_delay := 2


func _ready() -> void:
	Globals.balls_ready = 2
	spawn_bricks()
	get_tree().paused = true
	await get_tree().create_timer(2).timeout
	get_tree().paused = false


func _physics_process(_delta: float) -> void:
	tick_counter += 1
	brick_check_delay += 1
	if brick_check_delay == 1:
		check_level_end()
	if tick_counter % ball_respawn_rate == ball_respawn_rate - 1: # not just == 0 so ball doesn't spawn instantly
		if Globals.balls_ready < max_balls:
			EventBus.updated_balls_ready.emit()
			Globals.balls_ready += 1
	if tick_counter % sprinkler_respawn_rate == 0 and tick_counter > 30 * 60:
		spawn_sprinkler()
	if Input.is_action_just_pressed('confirm'):
		if Globals.balls_ready > 0:
			paddle.ball_on_deck.visible = true
	if Input.is_action_just_released('confirm'):
		if Globals.balls_ready > 0:
			paddle.ball_on_deck.visible = false
			spawn_ball()


func spawn_sprinkler() -> void:
	var new_sprinkler = sprinkler_scene.instantiate()
	new_sprinkler.global_position = Vector2(50, 50)
	new_sprinkler.radial_delta = PI / (randf_range(-5, 5))
	new_sprinkler.speed = randf() * 0.3 + 0.1
	new_sprinkler.direction = Vector2(randf(), -randf() * 0.5)
	new_sprinkler.global_position = Vector2(randf() * get_viewport_rect().size.x, get_viewport_rect().size.x / 3)
	if new_sprinkler.global_position.x > get_viewport_rect().size.x / 2:
		new_sprinkler.direction.x = -new_sprinkler.direction.x
	sprinkler_respawn_rate = roundi(sprinkler_respawn_rate * 0.95)
	add_child(new_sprinkler)


func spawn_ball() -> void:
	Globals.balls_ready -= 1
	EventBus.updated_balls_ready.emit()
	var new_ball = ball_scene.instantiate()
	new_ball.global_position = paddle.global_position
	new_ball.global_position.y -= 8 # todo magic #s
	new_ball.global_position.x += 12
	new_ball.direction = Vector2(0, -1)
	new_ball.direction.x += paddle.velocity.x * 0.5
	Globals.balls_in_play += 1
	EventBus.updated_balls_in_play.emit()
	add_child(new_ball)


func spawn_bricks() -> void:
	for brick in get_tree().get_nodes_in_group('bricks'):
		brick.brick_died.connect(on_brick_died)
	for col in range(1): # 7
		for row in range(2): # 8
			var new_brick = brick_scene.instantiate()
			# todo magic #'s
			new_brick.global_position = Vector2(col * 16 + 16, row * 4 + 20)
			new_brick.brick_died.connect(on_brick_died)
			add_child(new_brick)


func check_level_end() -> void:
	print(get_tree().get_nodes_in_group('bricks').size())
	if get_tree().get_nodes_in_group('bricks').is_empty():
		Globals.score += 10000
		levels_cleared += 1
		var new_end_screen = level_complete_ui.instantiate()
		add_child(new_end_screen)
		new_end_screen.next_level_pressed.connect(_on_next_level_pressed)


func _on_next_level_pressed() -> void:
	for ball in get_tree().get_nodes_in_group('balls'):
		ball.queue_free()
	for bullet in get_tree().get_nodes_in_group('bullets'):
		Globals.score += 10
		bullet.queue_free()
	for sprinkler in get_tree().get_nodes_in_group('sprinklers'):
		Globals.score += 500
		sprinkler.queue_free()




func on_brick_died() -> void:
	brick_check_delay = 0
	if get_tree().get_nodes_in_group('bricks').is_empty():
		Globals.score += 10000
