extends Pup

func activate() -> void:
	EventBus.got_wider_paddle.emit()
