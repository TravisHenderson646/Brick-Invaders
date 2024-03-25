extends StaticBody2D

@export var pattern: GDScript = preload('res://drip_pattern.gd')
func _physics_process(_delta: float) -> void:
	set_script(pattern)
