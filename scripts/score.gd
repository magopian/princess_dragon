extends Control

@onready var label_score: Label = $MarginContainer/HBoxContainer/LabelScore


func _ready() -> void:
	GameManager.new_score.connect(_on_new_score)


func _on_new_score(score: int) -> void:
	label_score.text = str(score)
