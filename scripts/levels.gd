extends Node

@onready var levels: Array[Node] = []
@onready var level_debug: Node2D = $LevelDebug
@onready var current_level: Node2D


func _ready() -> void:
	levels = get_children()


func start_game() -> void:
	var first_level: Node2D = levels[0]
	first_level.score_node = %Score
	# Move the score label up so it disappears
	%Score.position.y -= %Score.size.y
	%Score.show()
	change_level_to(first_level)


func debug_level() -> void:
	change_level_to(level_debug)


func change_level_to(level: Node2D) -> void:
	for child in get_children():
		child.hide()
		remove_child(child)
	add_child(level)
	current_level = level
	var finish: Area2D = current_level.find_child("Finish")
	if finish and finish.has_signal("level_finished"):
		finish.connect("level_finished", _on_level_finished)
	level.show()


func _on_level_finished():
	var current_index: int = levels.find(current_level)
	var next_level: Node2D = levels[current_index + 1]
	call_deferred("change_level_to", next_level)
