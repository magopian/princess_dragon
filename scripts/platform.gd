extends AnimatableBody2D

enum PLATFORM_CHOICES { grass, earth, sand, snow }

const platform_size = Vector2(32, 9)
const platform_regions = {
	PLATFORM_CHOICES.grass: Vector2(16, 0),
	PLATFORM_CHOICES.sand: Vector2(16, 16),
	PLATFORM_CHOICES.earth: Vector2(16, 32),
	PLATFORM_CHOICES.snow: Vector2(16, 48),
}

@export var platform_type: PLATFORM_CHOICES = PLATFORM_CHOICES.grass
@onready var player_on_platform: bool = false


func _ready() -> void:
	$Sprite2D.region_rect = Rect2(platform_regions.get(platform_type), platform_size)


func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("move_down") and player_on_platform:
		%CollisionShape2D.set_deferred("disabled", true)


func _on_area_2d_body_entered(body: Node2D) -> void:
	player_on_platform = body is Player


func _on_area_2d_body_exited(_body: Node2D) -> void:
	%CollisionShape2D.set_deferred("disabled", false)
	player_on_platform = false
