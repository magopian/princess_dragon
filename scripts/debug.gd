extends Control
signal jump_buffered
signal jump_coyoteyed
signal jump_cut

@export var DEBUG_MOVEMENT: bool = false


func _ready() -> void:
	if DEBUG_MOVEMENT:
		jump_buffered.connect(on_jump_buffered)
		jump_coyoteyed.connect(on_jump_coyoteyed)
		jump_cut.connect(on_jump_cut)


func on_jump_buffered() -> void:
	print("Jump buffered")


func on_jump_coyoteyed() -> void:
	print("Jump coyoteyed")


func on_jump_cut() -> void:
	print("Jump cut")
