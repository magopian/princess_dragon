extends Area2D


func _on_body_entered(body):
	GameManager.player_killed.emit(body)
