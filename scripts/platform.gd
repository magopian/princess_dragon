extends AnimatableBody2D

@onready var player_on_platform: bool = false


func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("move_down") and player_on_platform:
		%CollisionShape2D.set_deferred("disabled", true)


func _on_area_2d_body_entered(body: Node2D) -> void:
	player_on_platform = body is Player


func _on_area_2d_body_exited(_body: Node2D) -> void:
	%CollisionShape2D.set_deferred("disabled", false)
	player_on_platform = false
