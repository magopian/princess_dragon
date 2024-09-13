extends CanvasLayer

@export var level: Node2D
@onready var next_level: Button = %NextLevel
@onready var score_visible: bool


func _ready() -> void:
	next_level.grab_focus()


func _on_next_level_pressed() -> void:
	GameManager.next_level.emit(level)
