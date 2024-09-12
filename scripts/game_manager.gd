extends Node

signal add_point(coin: Area2D)
signal new_score(score: int, coin: Area2D)
signal show_score_ui
signal player_killed(body: Node2D)
signal restart_level
signal level_finished
signal start_game
signal start_level(level: Node2D)
signal start_debug_level

@onready var score: int:
	get = get_level_score,
	set = set_level_score
@onready var current_level: Node2D
@onready var score_per_level: Dictionary = {}


func _ready() -> void:
	add_point.connect(_on_add_point)
	restart_level.connect(reset_level_score)
	start_game.connect(reset_score)
	start_level.connect(_on_start_level)
	start_debug_level.connect(reset_score)


func get_total_score() -> int:
	var level_scores: Array = score_per_level.values()
	var total_score: int = level_scores.reduce(func(accum, number): return accum + number, 0)
	return total_score


func get_level_score() -> int:
	if current_level:
		return score_per_level.get(current_level.name, 0)
	else:
		return 0


func set_level_score(updated_score: int) -> void:
	score_per_level[current_level.name] = updated_score


func _on_add_point(coin: Area2D) -> void:
	score += 1
	new_score.emit(score, coin)


func _on_start_level(level: Node2D) -> void:
	current_level = level
	score = 0


func reset_score() -> void:
	score_per_level = {}


func reset_level_score() -> void:
	score = 0
