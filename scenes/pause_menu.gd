extends Control

@onready var back_to_the_game: Button = $"VBoxContainer/Back to the game"
@onready var back_to_main_menu: Button = $"VBoxContainer/Back to main menu"
@onready var quit: Button = $VBoxContainer/Quit
@onready var main_menu: PackedScene = preload("res://scenes/main_menu.tscn")


func _ready() -> void:
	display(false)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause_menu"):
		display(!visible)


func _on_back_to_the_game_pressed() -> void:
	display(false)


func _on_back_to_main_menu_pressed() -> void:
	get_tree().change_scene_to_packed(main_menu)


func _on_quit_pressed() -> void:
	get_tree().quit()


func display(is_displayed: bool) -> void:
	visible = is_displayed
	get_tree().paused = is_displayed
