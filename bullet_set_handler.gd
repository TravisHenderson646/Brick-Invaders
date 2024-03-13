extends Node2D

const enemy_spawner = preload('res://enemy_spawner.tscn')
const bullet_set1 = preload('res://bullet_set1.tscn')
const bullet_sprinkler = preload('res://bullet_sprinkler.tscn')

func _ready() -> void:
	var new_enemy_spawner = enemy_spawner.instantiate()
	new_enemy_spawner.bullet_set_finished.connect(_on_bullet_set_finished)
	add_child(new_enemy_spawner)


func _on_bullet_set_finished() -> void:
	for child in get_children():
		child.queue_free()
	var new_enemy_spawner = choose_bullet_set().instantiate()
	new_enemy_spawner.bullet_set_finished.connect(_on_bullet_set_finished)
	add_child(new_enemy_spawner)


func choose_bullet_set() -> Resource:
	return bullet_sprinkler
