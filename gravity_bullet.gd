class_name GravityBullet
extends Area2D


var velocity = Vector2.ZERO
var tick_counter := -1

func _physics_process(_delta: float) -> void:
	tick_counter += 1

	position += velocity
	velocity.y += .007
	if tick_counter >= 360:
		queue_free()


func die():
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Ball:
		Globals.score += 10
		die()
