extends Area2D

@onready var timer = $Timer
@onready var wasted_scene: PackedScene = preload("res://scenes/wasted.tscn")
@onready var wasted: CanvasLayer = wasted_scene.instantiate()


func _on_body_entered(body):
	print("WASTED")
	Engine.time_scale = 0.2
	get_tree().root.add_child(wasted)
	body.get_node("CollisionShape2D").queue_free()
	timer.start()


func _on_timer_timeout():
	Engine.time_scale = 1
	get_tree().root.remove_child(wasted)
	get_tree().reload_current_scene()
