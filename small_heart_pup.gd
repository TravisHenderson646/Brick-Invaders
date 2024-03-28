extends Pup


func activate() -> void:
	print('got small heartup')
	EventBus.got_small_heart.emit()
