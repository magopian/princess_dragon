extends Node2D

@export var randomStrength: float = 100.0
@export var shakeFade: float = 10.0

var parent: Node
var is_shaking: bool = false
var initial_position: Vector2
var rng = RandomNumberGenerator.new()
var shake_strength: float = 0.0
var shake_fade: float = 0.0

var shake_offset: bool = false


func _ready() -> void:
	parent = get_parent()
	shake_offset = "offset" in parent


func apply_shake(strength = randomStrength, fade = shakeFade):
	initial_position = parent.position
	is_shaking = true
	shake_strength = strength
	shake_fade = fade


func _process(delta: float) -> void:
	if not is_shaking:
		return

	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		if shake_offset:
			parent.offset = randomOffset()
		else:
			parent.position = initial_position + randomOffset()
	else:
		if shake_offset:
			parent.offset = Vector2.ZERO
		else:
			parent.position = initial_position
		is_shaking = false


func randomOffset() -> Vector2:
	return Vector2(
		rng.randf_range(-shake_strength, shake_strength),
		rng.randf_range(-shake_strength, shake_strength)
	)
