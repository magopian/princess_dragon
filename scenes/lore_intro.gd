extends Control

@onready var current_animation: String


func _ready() -> void:
	current_animation = "Start"
	$LoreAnimator.play(current_animation)


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		return

	if event.is_action_pressed("ui_accept"):
		if current_animation == "Start":
			current_animation = "PrincessAnswers"
			$LoreAnimator.play(current_animation)
		else:
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
