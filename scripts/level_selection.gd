extends Control

@onready
var level_selection_button: PackedScene = preload("res://scenes/level_selection_button.tscn")


func _ready() -> void:
	for level in %Levels.levels:
		create_button(level)
	var first_button = %LevelButtons.get_children()[0]
	var last_button = %LevelButtons.get_children()[-1]
	first_button.grab_focus()
	first_button.focus_neighbor_top = first_button.get_path_to(last_button)
	last_button.focus_neighbor_bottom = last_button.get_path_to(first_button)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("menu") and visible:
		get_tree().change_scene_to_file("res://scenes/savegame_selection.tscn")


func create_button(level: Node2D) -> void:
	var button: Button = level_selection_button.instantiate()
	button.text = level.name
	var score: Dictionary = GameManager.get_level_score(level)
	var coins_node: Node2D = level.get_node("Coins")
	var total_coins: int = 0
	if coins_node:
		total_coins = coins_node.get_child_count()
	button.get_node("%Coins").text = str(score["best_coins"]) + "/" + str(total_coins)
	button.get_node("%Time").text = str(score["best_time_elapsed"] / 1000)
	button.pressed.connect(level_selected.bind(level))
	%LevelButtons.add_child(button)


func level_selected(level: Node2D) -> void:
	hide()
	print("Selecting level: ", level)
	%Levels.change_level_to(level)
