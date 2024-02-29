extends PanelContainer


@onready var health_bar: ProgressBar = %HealthBar
@onready var points_total: Label = %PointsTotal


func _ready() -> void:
	EventBus.player_got_hit.connect(on_player_got_hit)
	EventBus.update_score.connect(on_update_score)


func on_player_got_hit() -> void:
	health_bar.value -= 1


func on_update_score(points) -> void:
	var wjfle = int(points_total.text)
	print(wjfle)
	points_total.text = str(wjfle + points)
