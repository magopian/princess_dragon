extends Node

@onready var levels: Array[Node] = []
@onready var level_debug: Node2D = $LevelDebug


func _ready() -> void:
	levels = get_children()


func start_game() -> void:
	var first_level: Node2D = levels[0]
	change_level_to(first_level)


func debug_level() -> void:
	change_level_to(level_debug)


func change_level_to(level: Node2D) -> void:
	for child in get_children():
		child.hide()
		remove_child(child)
	add_child(level)
	level.show()
