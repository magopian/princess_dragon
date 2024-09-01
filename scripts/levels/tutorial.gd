extends Node2D

@onready var score: Control


func _ready() -> void:
	score = get_tree().root.get_node("Game/UI/Score")
	# Move the score label up so it disappears
	score.position.y -= score.size.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	# Display the score label!
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(score, "position", Vector2.ZERO, 1).set_trans(Tween.TRANS_BOUNCE)
