extends CanvasLayer

@export var level: Node2D
@onready var next_level: Button = %NextLevel
@onready var score_visible: bool
@onready var coins_collected: Label = %CoinsCollected
@onready var time_elapsed: Label = %TimeElapsed


func _ready() -> void:
	next_level.grab_focus()
	coins_collected.text = str(GameManager.get_level_coins())
	time_elapsed.text = str(GameManager.get_time_elapsed() / 1000)


func _on_next_level_pressed() -> void:
	GameManager.next_level.emit(level)


func _on_restart_level_pressed() -> void:
	GameManager.restart_level.emit()
