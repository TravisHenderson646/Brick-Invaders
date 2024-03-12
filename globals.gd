extends Node


var levels := {
	# dont forget that the key test_level (and all of them) are strings not vars
	test_level = 'res://test_level.gd',
	level1 = 'res://level1.tscn'
}

var max_health := 8: #intentionally 1 larger than hp bar on hud
	set(new_value):
		max_health = new_value
		EventBus.updated_max_health.emit()

var health := 8:
	set(new_value):
		health = new_value
		EventBus.updated_health.emit()

var score := 0:
	set(new_value):
		score = new_value
		EventBus.updated_score.emit()

var balls_in_play := 0:
	set(new_value):
		balls_in_play = new_value
		EventBus.updated_balls_in_play.emit()

var balls_ready := 0:
	set(new_value):
		balls_ready = new_value
		EventBus.updated_balls_ready.emit()


var current_level := 0
