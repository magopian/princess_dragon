extends Control

var pause_menu_enabled: bool = true


func _ready() -> void:
	display(false)
	GameManager.pause_menu_enabled.connect(_on_pause_menu_enabled)


func _process(_delta: float) -> void:
	if not pause_menu_enabled:
		return

	if Input.is_action_just_pressed("menu"):
		if visible:
			_on_back_to_the_game_pressed()
		else:
			display(!visible)

func _on_pause_menu_enabled(enabled: bool) -> void:
	pause_menu_enabled = enabled

func _on_back_to_the_game_pressed() -> void:
	display(false)


func _on_back_to_main_menu_pressed() -> void:
	display(false)
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()


func display(is_displayed: bool) -> void:
	visible = is_displayed
	get_tree().paused = is_displayed
	if visible:
		%LevelTitle.text = GameManager.current_level.name


func _on_visibility_changed() -> void:
	if visible:
		%"Back to the game".grab_focus()


func _on_restart_the_level_pressed() -> void:
	display(false)
	GameManager.restart_level.emit()
