extends Node

@onready var levels: Array[Node] = []
@onready var current_level: Node2D
@onready var level_debug: Node2D = $"Debug Level"


func _ready() -> void:
	levels = get_children()
	disable_levels()
	GameManager.restart_level.connect(reload_level)
	GameManager.level_finished.connect(_on_level_finished)
	GameManager.start_game.connect(start_game)
	GameManager.start_debug_level.connect(debug_level)


func start_game() -> void:
	var first_level: Node2D = levels[0]
	print("start game")
	change_level_to(first_level)


func debug_level() -> void:
	change_level_to(level_debug)


func start_level(level: Node2D) -> void:
	level = load(level.scene_file_path).instantiate()
	add_child(level)
	GameManager.start_level.emit(level)


func change_level_to(level: Node2D) -> void:
	current_level = level
	disable_levels()
	start_level(current_level)


func reload_level() -> void:
	change_level_to(current_level)


func disable_levels() -> void:
	for child in get_children():
		remove_child(child)


func _on_level_finished() -> void:
	var current_index: int = levels.find(current_level)
	current_index = clamp(current_index + 1, 0, levels.size() - 1)
	var next_level: Node2D = levels[current_index]
	call_deferred("change_level_to", next_level)
