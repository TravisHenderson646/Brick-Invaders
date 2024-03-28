extends StaticBody2D

const bullet_scene = preload('res://gravity_bullet.tscn')
var tick_counter := -1
var stun_length := 600
var stun_timer := stun_length
var spawn_rate = 0
#var bullet_patterns = bullet_pattern.new()

func _init() -> void:
	spawn_rate = randi() % 200 + 300

func _physics_process(_delta: float) -> void:
	tick_counter += 1
	stun_timer += 1
	if stun_timer > stun_length:
		spawn_bullet(position, get_tree().current_scene)

func _get_hit() -> void:
	stun_timer = 0


func spawn_bullet(pos, main_node) -> void:
	if not tick_counter % spawn_rate and tick_counter != 0:
		tick_counter = 0
		spawn_rate = randi() % 200 + 100
		var new_bullet = bullet_scene.instantiate()
		new_bullet.position = pos
		main_node.add_child(new_bullet)
