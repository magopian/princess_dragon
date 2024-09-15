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
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
