extends Control

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var start: Button = $CanvasLayer/Buttons/Start
@onready var debug_scene: PackedScene = preload("res://scenes/level_debug.tscn")


func _ready() -> void:
	start.grab_focus()


func _process(_delta) -> void:
	pass
	#if Input.is_action_just_pressed("menu"):
	#	canvas_layer.visible = not canvas_layer.visible


func _on_start_pressed() -> void:
	canvas_layer.visible = false


func _on_debug_pressed() -> void:
	get_tree().change_scene_to_packed(debug_scene)


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_canvas_layer_visibility_changed() -> void:
	if canvas_layer.visible:
		start.grab_focus()
