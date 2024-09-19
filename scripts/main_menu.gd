extends Control

@onready var start: Button = $MarginContainer/Buttons/Start
@onready var version_label: Label = %VersionLabel


func _ready() -> void:
	start.grab_focus()
	version_label.text += ProjectSettings.get_setting("application/config/version")


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("menu"):
		get_tree().quit()


func _on_start_pressed() -> void:
	if GameManager.user_prefs.savegame_file:
		# We already have an existing savegame file, go straight to the level selection.
		get_tree().change_scene_to_file("res://scenes/game.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/savegame_selection.tscn")


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/options_menu.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
