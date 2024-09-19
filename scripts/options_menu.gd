extends Control


func _ready() -> void:
	var user_prefs: UserPreferences = GameManager.user_prefs
	%Muted.button_pressed = user_prefs.muted
	%Muted.toggled.connect(GameManager.muted_preference_changed.emit)
	%MainMenu.grab_focus()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		_on_main_menu_pressed()


func _on_savegame_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/savegame_selection.tscn")


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
