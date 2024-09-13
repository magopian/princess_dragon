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
signal next_level(level: Node2D)

@onready var score: int:
	get = get_level_coins,
	set = set_level_coins
@onready var current_level: Node2D
@onready var score_per_level: Dictionary = {}
@onready var time_started: float

const empty_score: Dictionary = {"coins": 0, "time_elapsed": 0}


func _ready() -> void:
	add_point.connect(_on_add_point)
	restart_level.connect(reset_level_score)
	start_game.connect(reset_score)
	start_level.connect(_on_start_level)
	start_debug_level.connect(reset_score)
	level_finished.connect(save_time_elapsed)


func _process(_delta: float) -> void:
	pass


func get_total_coins() -> int:
	var level_scores: Array = score_per_level.values()
	var total_coins: int = level_scores.reduce(func(accum, score): return accum + score["coins"], 0)
	return total_coins


func get_level_coins() -> int:
	if current_level:
		return score_per_level.get(current_level.name, {"coins": 0})["coins"]
	else:
		return 0


func set_level_coins(updated_coins: int) -> void:
	if not current_level:
		# When running the current scene instead of running the game.
		return
	var updated_score: Dictionary = score_per_level.get(current_level.name, empty_score.duplicate())
	updated_score["coins"] = updated_coins
	score_per_level[current_level.name] = updated_score


func get_level_score() -> Dictionary:
	if current_level:
		return score_per_level.get(current_level.name, empty_score)
	else:
		return empty_score


func get_time_elapsed() -> float:
	if not current_level:
		return 0
	return Time.get_ticks_msec() - time_started


func save_time_elapsed() -> void:
	score_per_level[current_level.name]["time_elapsed"] = get_time_elapsed()


func _on_add_point(coin: Area2D) -> void:
	score += 1
	new_score.emit(score, coin)


func _on_start_level(level: Node2D) -> void:
	current_level = level
	reset_level_score()
	time_started = Time.get_ticks_msec()


func reset_score() -> void:
	score_per_level = {}


func reset_level_score() -> void:
	score = 0
