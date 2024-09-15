extends Control


func _ready() -> void:
	for level in %Levels.levels:
		create_button(level)
	var first_button = %LevelButtons.get_children()[0]
	var last_button = %LevelButtons.get_children()[-1]
	print("first button: ", first_button)
	print("last button: ", last_button)
	first_button.grab_focus()
	first_button.focus_neighbor_top = first_button.get_path_to(last_button)
	last_button.focus_neighbor_bottom = last_button.get_path_to(first_button)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func create_button(level: Node2D) -> void:
	var button: Button = Button.new()
	button.text = level.name
	button.add_theme_font_size_override("font_size", 8)
	button.pressed.connect(level_selected.bind(level))
	%LevelButtons.add_child(button)


func level_selected(level: Node2D) -> void:
	hide()
	print("Selecting level: ", level)
	%Levels.change_level_to(level)
