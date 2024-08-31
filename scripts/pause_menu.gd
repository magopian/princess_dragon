extends Control

@onready var back_to_the_game: Button = $"MarginContainer/VBoxContainer/Back to the game"
@onready var back_to_main_menu: Button = $"MarginContainer/VBoxContainer/Back to main menu"
@onready var quit: Button = $MarginContainer/VBoxContainer/Quit

@onready var main_menu: Control = %MainMenu


func _ready() -> void:
	display(false)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause_menu"):
		display(!visible)


func _on_back_to_the_game_pressed() -> void:
	display(false)


func _on_back_to_main_menu_pressed() -> void:
	display(false)
	process_mode = Node.PROCESS_MODE_DISABLED
	main_menu.display(true)


func _on_quit_pressed() -> void:
	get_tree().quit()


func display(is_displayed: bool) -> void:
	visible = is_displayed
	get_tree().paused = is_displayed


func _on_visibility_changed() -> void:
	if visible:
		back_to_the_game.grab_focus()
