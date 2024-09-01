extends Area2D

signal level_finished


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		print("level finished!")
		level_finished.emit()
