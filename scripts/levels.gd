extends Node

@onready var levels: Array[Node] = []
@onready var current_level: Node2D
@onready var level_debug: Node2D = $"Debug Level"
@onready var level_finished_screen: PackedScene = preload("res://scenes/level_finished.tscn")
var level_finished_screen_instantiated: CanvasLayer


func _ready() -> void:
	levels = get_children()
	disable_levels()
	GameManager.restart_level.connect(reload_level)
	GameManager.level_finished.connect(_on_level_finished)
	GameManager.start_game.connect(start_game)
	GameManager.start_debug_level.connect(start_debug_level)
	GameManager.next_level.connect(start_next_level)


func start_game() -> void:
	var first_level: Node2D = levels[0]
	print("start game")
	change_level_to(first_level)


func start_debug_level() -> void:
	change_level_to(level_debug)


func start_level(level: Node2D) -> void:
	level = load(level.scene_file_path).instantiate()
	add_child(level)
	level.process_mode = Node.PROCESS_MODE_INHERIT
	GameManager.start_level.emit(level)


func change_level_to(level: Node2D) -> void:
	current_level = level
	disable_levels()
	start_level(current_level)


func reload_level() -> void:
	remove_level_finished_screen()
	change_level_to(current_level)


func disable_levels() -> void:
	for child in get_children():
		remove_child(child)
		child.process_mode = Node.PROCESS_MODE_DISABLED


func _on_level_finished() -> void:
	get_tree().paused = true
	display_level_finished_screen(current_level)


func display_level_finished_screen(level: Node2D) -> void:
	level_finished_screen_instantiated = level_finished_screen.instantiate()
	level_finished_screen_instantiated.level = level
	add_child(level_finished_screen_instantiated)


func remove_level_finished_screen() -> void:
	if level_finished_screen_instantiated:
		remove_child(level_finished_screen_instantiated)
		level_finished_screen_instantiated.queue_free()
		level_finished_screen_instantiated = null
	get_tree().paused = false


func start_next_level(from_level: Node2D) -> void:
	remove_level_finished_screen()
	var current_index: int = levels.find(from_level)
	current_index = clamp(current_index + 1, 0, levels.size() - 1)
	var next_level: Node2D = levels[current_index]
	call_deferred("change_level_to", next_level)
