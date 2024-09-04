extends Node2D

@onready var score_node: Control


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	if not score_node:
		return
	# Display the score label!
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(score_node, "position", Vector2.ZERO, 1).set_trans(Tween.TRANS_BOUNCE)
