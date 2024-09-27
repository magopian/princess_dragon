extends ColorRect


func _ready() -> void:
	visible = true
	%Timer.timeout.connect(_on_timeout)
	get_tree().paused = true
	%StartNow.grab_focus()
	%StartNow.pressed.connect(start_level)


func _process(_delta: float) -> void:
	%LevelName.text = GameManager.get_level_name()
	var time_left: int = ceil(%Timer.time_left)

	if str(time_left) != %StartingIn.text:
		animate_new_number()
		%StartingIn.text = str(time_left)


func _on_timeout() -> void:
	start_level()


func start_level() -> void:
	visible = false
	get_tree().paused = false
	%Timer.stop()
	GameManager.level_started.emit()


func animate_new_number() -> void:
	%CountdownSound.play()
	%StartingIn.scale = Vector2(2.5, 2.5)
	%StartingIn.modulate.a = 1
	var tween: Tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(%StartingIn, "scale", Vector2(1, 1), 0.9)
	tween.tween_property(%StartingIn, "modulate:a", 0, 0.9)
