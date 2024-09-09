extends Node

signal new_score(score: int, coin: Area2D)
signal show_score_ui
signal player_killed(body: Node2D)
signal restart_level
signal level_finished

@onready var score: int = 0
# Score is "banked" once the level changes to the next level.
@onready var score_banked: int = 0


func _ready() -> void:
	player_killed.connect(reset_score_to_banked.unbind(1))
	restart_level.connect(reset_score_to_banked)
	level_finished.connect(bank_score)


func add_point(coin: Area2D):
	score += 1
	new_score.emit(score, coin)


func bank_score() -> void:
	score_banked = score


func reset_score_to_banked() -> void:
	score = score_banked
