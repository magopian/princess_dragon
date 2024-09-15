extends Node

signal add_point(coin: Area2D)
signal new_score(score: int, coin: Area2D)
signal show_score_ui
signal player_killed(body: Node2D)
signal restart_level
signal level_finished
signal start_level(level: Node2D)
signal next_level(level: Node2D)

@onready var score: int:
	get = get_level_coins,
	set = set_level_coins
@onready var current_level: Node2D
@onready var score_per_level: Dictionary = {}
@onready var time_started: float

const empty_score: Dictionary = {
	"coins": 0, "best_coins": 0, "time_elapsed": 0, "best_time_elapsed": 0
}


func _ready() -> void:
	add_point.connect(_on_add_point)
	restart_level.connect(reset_level_score)
	start_level.connect(_on_start_level)
	level_finished.connect(save_level_score)

	load_game_save()


func get_level_name() -> String:
	if not current_level:
		return "no current level"
	return current_level.name


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


func get_level_score(level: Node2D) -> Dictionary:
	return score_per_level.get(level.name, empty_score)


func get_time_elapsed() -> float:
	if not current_level:
		return 0
	return Time.get_ticks_msec() - time_started


func save_level_score() -> void:
	var time_elapsed: float = get_time_elapsed()
	score_per_level[current_level.name]["time_elapsed"] = time_elapsed
	var best_time_elapsed: float = score_per_level[current_level.name]["best_time_elapsed"]
	if time_elapsed < best_time_elapsed or best_time_elapsed == 0:
		score_per_level[current_level.name]["best_time_elapsed"] = time_elapsed
	if get_level_coins() > score_per_level[current_level.name]["best_coins"]:
		score_per_level[current_level.name]["best_coins"] = get_level_coins()
	save_score_to_file()


func _on_add_point(coin: Area2D) -> void:
	score += 1
	new_score.emit(score, coin)


func _on_start_level(level: Node2D) -> void:
	current_level = level
	reset_level_score()
	time_started = Time.get_ticks_msec()


func reset_level_score() -> void:
	score = 0


func save_score_to_file() -> void:
	var save_file: FileAccess = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var json_string: String = JSON.stringify(score_per_level)
	save_file.store_line(json_string)


func load_game_save() -> void:
	if not FileAccess.file_exists("user://savegame.save"):
		return  # Error! We don't have a save to load.

	var save_file: FileAccess = FileAccess.open("user://savegame.save", FileAccess.READ)
	var json_string: String = save_file.get_line()
	var json: JSON = JSON.new()
	var parse_result: Error = json.parse(json_string)

	if not parse_result == OK:
		print(
			"JSON Parse Error: ",
			json.get_error_message(),
			" in ",
			json_string,
			" at line ",
			json.get_error_line()
		)
		return
	score_per_level = json.get_data()
	print("Loaded the saved game: ", score_per_level)
