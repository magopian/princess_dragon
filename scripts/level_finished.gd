extends CanvasLayer

@export var level: Node2D
@onready var next_level: Button = %NextLevel
@onready var score_visible: bool
@onready var level_name: Label = %LevelName
@onready var coins: Label = %Coins
@onready var time: Label = %Time
@onready var best_coins: Label = %BestCoins
@onready var new_best_coins: Label = %NewBestCoins
@onready var best_time: Label = %BestTime
@onready var new_best_time: Label = %NewBestTime


func _ready() -> void:
	next_level.grab_focus()
	level_name.text = GameManager.get_level_name()
	var level_score: Dictionary = GameManager.get_level_score()
	coins.text = str(level_score["coins"])
	best_coins.text = str(level_score["best_coins"])
	time.text = str(level_score["time_elapsed"] / 1000)
	best_time.text = str(level_score["best_time_elapsed"] / 1000)
	new_best_coins.visible = coins.text == best_coins.text
	new_best_time.visible = time.text == best_time.text


func _on_next_level_pressed() -> void:
	GameManager.next_level.emit(level)


func _on_restart_level_pressed() -> void:
	GameManager.restart_level.emit()
