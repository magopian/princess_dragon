extends Control

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var start: Button = $CanvasLayer/Buttons/Start


func _ready() -> void:
	start.grab_focus()


func _process(_delta) -> void:
	if Input.is_action_just_pressed("menu"):
		canvas_layer.visible = not canvas_layer.visible


func _on_start_pressed() -> void:
	canvas_layer.visible = false


func _on_debug_pressed() -> void:
	print("load the debug scene")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_canvas_layer_visibility_changed() -> void:
	if canvas_layer.visible:
		start.grab_focus()
