extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		print("level finished!")
		GameManager.level_finished.emit()
