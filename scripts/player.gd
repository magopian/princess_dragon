extends CharacterBody2D

@onready var coyote_timer: Timer = $CoyoteTimer
@onready var jump_buffer_timer: Timer = $JumpBufferTimer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var SPEED: float = 100.0
@export var JUMP_VELOCITY: float = -300.0
@export var COYOTE_TIME: float = 0.1
@export var JUMP_BUFFER: float = 0.1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	handle_jump()
	var direction: float = get_direction()
	handle_animations(direction)
	apply_movement(direction)


func handle_jump():
	# Jump buffer
	if Input.is_action_just_pressed("jump") and not is_on_floor():
		jump_buffer_timer.start(JUMP_BUFFER)

	if (Input.is_action_just_pressed("jump") or jump_buffer_timer.time_left) and can_jump():
		if jump_buffer_timer.time_left:
			print("JUMP BUFFER")
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

	var was_on_floor: bool = is_on_floor()
	move_and_slide()
	if was_on_floor and not is_on_floor() and not is_jumping():
		coyote_timer.start(COYOTE_TIME)


func is_jumping() -> bool:
	return velocity.y < 0


func can_jump() -> bool:
	if is_on_floor():
		return true
	if coyote_timer.time_left > 0:
		return true
	return false
