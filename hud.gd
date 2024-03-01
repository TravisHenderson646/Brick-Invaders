extends PanelContainer


@onready var health_bar: ProgressBar = %HealthBar
@onready var points_total: Label = %PointsTotal
@onready var balls_count: Label = %BallsCount

var num_balls := 1

func _ready() -> void:
	EventBus.player_got_hit.connect(on_player_got_hit)
	EventBus.update_score.connect(on_update_score)
	EventBus.update_ball_count.connect(on_update_ball_count)


func on_update_ball_count(change) -> void:
	num_balls += change
	match num_balls:
		0:
			balls_count.text = ''
		1:
			balls_count.text = ' X'
		2:
			balls_count.text = ' X X'
		3:
			balls_count.text = ' X X X'


func on_player_got_hit() -> void:
	health_bar.value -= 1


func on_update_score(points) -> void:
	var _num = int(points_total.text)
	points_total.text = str(_num + points)
