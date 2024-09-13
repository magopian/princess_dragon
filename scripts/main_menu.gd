extends Control

@onready var pause_menu: Control = %PauseMenu
@onready var start: Button = $MarginContainer/Buttons/Start
@onready var version_label: Label = %VersionLabel


func _ready() -> void:
	display(true)
	pause_menu.display(false)
	start.grab_focus()
	version_label.text += ProjectSettings.get_setting("application/config/version")


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause_menu") and visible:
		get_tree().quit()


func _on_start_pressed() -> void:
	display(false)
	GameManager.start_game.emit()


func _on_debug_pressed() -> void:
	display(false)
	GameManager.start_debug_level.emit()


func _on_quit_pressed() -> void:
	get_tree().quit()


func display(is_displayed: bool) -> void:
	visible = is_displayed
	get_tree().paused = is_displayed


func _on_visibility_changed() -> void:
	if visible:
		start.grab_focus()
