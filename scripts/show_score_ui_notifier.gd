extends Node2D


func _on_screen_entered() -> void:
	GameManager.show_score_ui.emit()
