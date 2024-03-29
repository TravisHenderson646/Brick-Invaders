extends Node2D


@onready var level_complete_ui: LevelCompleteUI = $LevelCompleteUI
@onready var paddle: Paddle = $Paddle

const ball_scene = preload('res://ball.tscn')
const brick_scene = preload('res://brick.tscn')
const level_prefab1 = preload('res://level_prefab1.tscn')

const levels = [
	#preload('res://one_brick_level.tscn'),
	preload('res://easy_level.tscn'),
	preload('res://cavern_level.tscn'),
	preload('res://eye_level.tscn'),
	preload('res://fun_level.tscn'),
]

var tick_counter := -1
var max_balls := 3
var ball_respawn_rate := 1200
var brick_check_delay := 2
var current_lvl := 0

func _ready() -> void:
	remove_child(level_complete_ui)
	level_complete_ui.next_level_pressed.connect(_on_next_level_pressed)
	Globals.balls_ready = Globals.num_start_balls
	spawn_level()


func _physics_process(_delta: float) -> void:
	tick_counter += 1
	brick_check_delay += 1
	if brick_check_delay == 1:
		check_level_end()
	if Input.is_action_just_pressed('confirm'):
		if Globals.balls_ready > 0:
			paddle.ball_on_deck.visible = true
	if Input.is_action_just_released('confirm'):
		if Globals.balls_ready > 0:
			paddle.ball_on_deck.visible = false
			spawn_ball()


func spawn_ball() -> void:
	Globals.balls_ready -= 1
	EventBus.updated_balls_ready.emit()
	var new_ball = ball_scene.instantiate()
	new_ball.global_position = paddle.global_position
	new_ball.global_position.y -= 12 # todo magic #s
	new_ball.global_position.x -= 4
	new_ball.direction = Vector2(0, -1)
	new_ball.direction.x += paddle.velocity.x * 0.5
	Globals.balls_in_play += 1
	EventBus.updated_balls_in_play.emit()
	add_child(new_ball)


func spawn_level() -> void:
	var new_level = levels[current_lvl].instantiate()
	find_child('LevelPrefabHolder').add_child(new_level)
	for brick in get_tree().get_nodes_in_group('bricks'):
		brick.brick_died.connect(on_brick_died)
	get_tree().paused = true
	await get_tree().create_timer(2).timeout
	get_tree().paused = false

func on_brick_died() -> void:
	brick_check_delay = 0

func check_level_end() -> void:
	if get_tree().get_nodes_in_group('bricks').is_empty():
		current_lvl = (current_lvl + 1) % levels.size()
		Globals.score += 50
		for ball in get_tree().get_nodes_in_group('balls'):
			Globals.score += 20
		for bullet in get_tree().get_nodes_in_group('bullets'):
			Globals.score += 1
		add_child(level_complete_ui)
		level_complete_ui.setup()
		get_tree().paused = true


func _on_next_level_pressed() -> void:
	remove_child(level_complete_ui)
	for node in get_tree().get_nodes_in_group('delete'):
		node.queue_free()
	print(Globals.num_start_balls)
	Globals.balls_ready = Globals.num_start_balls
	spawn_level()


func next_level_cleanup() -> void:
	for node in get_tree().get_nodes_in_group('delete'):
		node.queue_free()
	Globals.balls_in_play = 0
