extends StaticBody2D

const bullet_scene = preload('res://gravity_bullet.tscn')
var tick_counter := -1
var stun_length := 600
var stun_timer := stun_length
var spawn_rate = randi() % 2 + 3
var spread = 0.5

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
	if not tick_counter % spawn_rate and tick_counter != 0:
		spawn_rate = randi() % 20 + 30
		var new_bullet = bullet_scene.instantiate()
		new_bullet.position = pos
		new_bullet.velocity.y = -0.6 + randf() * 0.5
		new_bullet.velocity.x = randf() * spread - spread / 2
		main_node.add_child(new_bullet)
