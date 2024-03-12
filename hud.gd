extends PanelContainer


@onready var health_bar: ProgressBar = %HealthBar
@onready var points_total: Label = %PointsTotal
@onready var balls_count: Label = %BallsCount

var num_balls := 1

func _ready() -> void:
	points_total.text = str(Globals.score)
	health_bar.value = Globals.health - 1
	EventBus.updated_health.connect(_on_updated_health)
	EventBus.updated_score.connect(_on_updated_score)
	EventBus.updated_balls_in_play.connect(_on_updated_balls_in_play)
	EventBus.updated_balls_ready.connect(_on_updated_balls_ready)

func _on_updated_balls_in_play() -> void: pass

func _on_updated_balls_ready() -> void:
	match Globals.balls_ready:
		0:
			balls_count.text = ''
		1:
			balls_count.text = ' X'
		2:
			balls_count.text = ' X X'
		3:
			balls_count.text = ' X X X'


func _on_updated_health() -> void:
	health_bar.value = Globals.health - 1


func _on_updated_score() -> void:
	points_total.text = str(Globals.score)
