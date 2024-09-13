extends Label


func _process(delta: float) -> void:
	text = str(GameManager.get_time_elapsed() / 1000)
