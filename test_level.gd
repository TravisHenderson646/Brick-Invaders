extends Node2D

@onready var paddle: Paddle = $Paddle

const ball_scene = preload('res://ball.tscn')
const brick_scene = preload('res://brick.tscn')
const sprinkler_scene = preload('res://bullet_sprinkler.tscn')

var tick_counter := -1
var balls := 1
var max_balls := 3
var ball_respawn_rate := 1200
var sprinkler_respawn_rate := 1200
var sprinkler_respawn_rate_default := 1200
var levels_cleared := 0


func _ready() -> void:
	spawn_bricks()


func _physics_process(_delta: float) -> void:
	tick_counter += 1
	if tick_counter % ball_respawn_rate == ball_respawn_rate - 1: # not just == 0 so ball doesn't spawn instantly
		if balls < max_balls:
			EventBus.update_ball_count.emit(1)
			balls += 1
	if tick_counter % sprinkler_respawn_rate == 0 and tick_counter > 30 * 60:
		spawn_sprinkler()
	if Input.is_action_just_pressed('confirm'):
		if balls > 0:
			paddle.ball_on_deck.visible = true
	if Input.is_action_just_released('confirm'):
		if balls > 0:
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
	balls -= 1
	var new_ball = ball_scene.instantiate()
	new_ball.global_position = paddle.global_position
	new_ball.global_position.y -= 8 # todo magic #s
	new_ball.global_position.x += 12
	new_ball.direction = Vector2(0, -1)
	new_ball.direction.x += paddle.velocity.x * 0.5
	EventBus.update_ball_count.emit(-1)
	add_child(new_ball)


func spawn_bricks() -> void:
	for col in range(8): # 8
		for row in range(7): # 7
			var new_brick = brick_scene.instantiate()
			# todo magic #'s
			new_brick.global_position = Vector2(row * 16 + 16, col * 4 + 20)
			new_brick.brick_died.connect(on_brick_died)
			add_child(new_brick)


func on_brick_died() -> void:
	await get_tree().create_timer(20).timeout
	if get_tree().get_nodes_in_group('bricks').is_empty():
		EventBus.update_score.emit(10000)
		spawn_bricks()
		levels_cleared += 1
		sprinkler_respawn_rate = roundi(sprinkler_respawn_rate_default * (0.95 ** levels_cleared))
		for ball in get_tree().get_nodes_in_group('balls'):
			ball.queue_free()
		for bullet in get_tree().get_nodes_in_group('bullets'):
			EventBus.update_score.emit(10)
			bullet.queue_free()
		for sprinkler in get_tree().get_nodes_in_group('sprinklers'):
			EventBus.update_score.emit(500)
			sprinkler.queue_free()

