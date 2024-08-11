extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D

@export var SPEED = 100.0
@export var JUMP_VELOCITY = -300.0
@export var COYOTE_TIME = 0.1
@onready var coyote_timer = $CoyoteTimer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	handle_jump()
	var direction : float = get_direction()	
	handle_animations(direction)
	apply_movement(direction)

func handle_jump():
	if Input.is_action_just_pressed("jump") and can_jump():
		if coyote_timer.time_left:
			print("coyote time!!")
		velocity.y = JUMP_VELOCITY
	
func get_direction() -> float:
	# Get the input direction: -1, 0, 1
	return Input.get_axis("move_left", "move_right")

func handle_animations(direction):
	# Flip the sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	# Play animation
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")

func apply_movement(direction):
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	var was_on_floor : bool = is_on_floor()
	move_and_slide()
	if was_on_floor and not is_on_floor() and not is_jumping():
		coyote_timer.start(COYOTE_TIME)

func is_jumping() -> bool:
	return velocity.y < 0

func can_jump() -> bool:
	return is_on_floor() or coyote_timer.time_left > 0
