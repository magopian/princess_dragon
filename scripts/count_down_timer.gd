extends ColorRect


func _ready() -> void:
	visible = true
	%Timer.timeout.connect(_on_timeout)
	get_tree().paused = true
	%StartNow.grab_focus()
	%StartNow.pressed.connect(start_level)


func _process(delta: float) -> void:
	%LevelName.text = GameManager.get_level_name()
	var time_left: int = ceil(%Timer.time_left)
	%StartingIn.text = str(time_left)


func _on_timeout() -> void:
	start_level()


func start_level() -> void:
	visible = false
	get_tree().paused = false
	GameManager.level_started.emit()
