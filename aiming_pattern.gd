extends StaticBody2D

@export var spawn_rate := 40

const bullet_scene = preload('res://bullet.tscn')
var tick_counter := -1
var stun_length := 600
var stun_timer := stun_length
#var bullet_patterns = bullet_pattern.new()

func _init() -> void:
	pass


func _physics_process(_delta: float) -> void:
	tick_counter += 1
	stun_timer += 1
	if stun_timer > stun_length:
		spawn_bullet(position, get_tree().current_scene)

func _get_hit() -> void:
	stun_timer = 0


func spawn_bullet(pos, main_node) -> void:
	if not tick_counter % spawn_rate:
		var new_bullet = bullet_scene.instantiate()
		new_bullet.position = pos
		new_bullet.direction = new_bullet.position.direction_to(get_tree().get_first_node_in_group('paddle').position)
		main_node.add_child(new_bullet)
