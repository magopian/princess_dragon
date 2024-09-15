extends Control

@onready var back_to_the_game: Button = $"MarginContainer/VBoxContainer/Back to the game"


func _ready() -> void:
	display(false)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("menu"):
		if visible:
			_on_back_to_the_game_pressed()
		else:
			display(!visible)


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


func _on_visibility_changed() -> void:
	if visible:
		back_to_the_game.grab_focus()


func _on_restart_the_level_pressed() -> void:
	display(false)
	GameManager.restart_level.emit()
