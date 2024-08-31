extends Control

@onready var levels: Node = %Levels
@onready var pause_menu: Control = %PauseMenu
@onready var start: Button = $MarginContainer/Buttons/Start


func _ready() -> void:
	display(true)
	pause_menu.display(false)
	pause_menu.process_mode = Node.PROCESS_MODE_DISABLED
	start.grab_focus()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause_menu") and visible:
		get_tree().quit()


func _on_start_pressed() -> void:
	display(false)
	pause_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	%Levels.start_game()


func _on_debug_pressed() -> void:
	display(false)
	pause_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	%Levels.debug_level()


func _on_quit_pressed() -> void:
	get_tree().quit()


func display(is_displayed: bool) -> void:
	visible = is_displayed
	get_tree().paused = is_displayed


func _on_visibility_changed() -> void:
	if visible:
		pause_menu.process_mode = Node.PROCESS_MODE_DISABLED
		start.grab_focus()
