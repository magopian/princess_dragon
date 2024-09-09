extends Node

@onready var levels: Array[Node] = []
@onready var current_level: Node2D
@onready var level_debug: Node2D = $"Debug Level"

@onready var wasted_scene: PackedScene = preload("res://scenes/wasted.tscn")
@onready var wasted: CanvasLayer = wasted_scene.instantiate()


func _ready() -> void:
	levels = get_children()
	disable_levels()
	GameManager.player_killed.connect(_on_player_killed)
	GameManager.restart_level.connect(reload_level)
	GameManager.level_finished.connect(_on_level_finished)


func start_game() -> void:
	var first_level: Node2D = levels[0]
	print("start game")
	change_level_to(first_level)


func debug_level() -> void:
	change_level_to(level_debug)


func change_level_to(level: Node2D) -> void:
	disable_levels()
	add_child(level)
	current_level = level
	var finish: Area2D = current_level.find_child("Finish")
	level.process_mode = Node.PROCESS_MODE_INHERIT
	level.show()


func reload_level() -> void:
	remove_child(current_level)
	current_level = load(current_level.scene_file_path).instantiate()
	add_child(current_level)


func disable_levels() -> void:
	for child in get_children():
		child.hide()
		child.process_mode = Node.PROCESS_MODE_DISABLED
		remove_child(child)


func _on_level_finished() -> void:
	var current_index: int = levels.find(current_level)
	var next_level: Node2D = levels[current_index + 1]
	call_deferred("change_level_to", next_level)


func _on_player_killed(body) -> void:
	Engine.time_scale = 0.2
	get_tree().root.add_child(wasted)
	body.get_node("CollisionShape2D").queue_free()
	await get_tree().create_timer(0.2).timeout
	Engine.time_scale = 1
	reload_level()
	get_tree().root.remove_child(wasted)
