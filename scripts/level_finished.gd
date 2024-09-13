extends CanvasLayer

@export var level: Node2D
@onready var next_level: Button = %NextLevel
@onready var score_visible: bool
@onready var coins_collected: Label = %CoinsCollected
@onready var time_elapsed: Label = %TimeElapsed
@onready var level_name: Label = %LevelName
@onready var best_coins_collected: Label = %BestCoinsCollected
@onready var best_time_elapsed: Label = %BestTimeElapsed


func _ready() -> void:
	next_level.grab_focus()
	level_name.text = GameManager.get_level_name()
	var level_score: Dictionary = GameManager.get_level_score()
	coins_collected.text = str(level_score["coins"])
	best_coins_collected.text = str(level_score["best_coins"])
	time_elapsed.text = str(level_score["time_elapsed"] / 1000)
	best_time_elapsed.text = str(level_score["best_time_elapsed"] / 1000)


func _on_next_level_pressed() -> void:
	GameManager.next_level.emit(level)


func _on_restart_level_pressed() -> void:
	GameManager.restart_level.emit()
