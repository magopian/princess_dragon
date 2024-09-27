extends BaseEnemy

var direction = 1
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_bottom_right: RayCast2D = $RayCastBottomRight
@onready var ray_cast_bottom_left: RayCast2D = $RayCastBottomLeft
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var SPEED: float = 50


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ray_cast_right.is_colliding() or not ray_cast_bottom_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if ray_cast_left.is_colliding() or not ray_cast_bottom_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
	if rotation:
		position.y += direction * SPEED * delta
	else:
		position.x += direction * SPEED * delta
