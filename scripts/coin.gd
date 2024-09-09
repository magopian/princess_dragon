extends Area2D

@onready var animation_player = $AnimationPlayer


func _on_body_entered(_body):
	GameManager.add_point.emit(self)
	animation_player.play("pickup")
