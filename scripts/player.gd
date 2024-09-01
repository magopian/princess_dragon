class_name Player extends CharacterBody2D

@onready var coyote_timer: Timer = $CoyoteTimer
@onready var jump_buffer_timer: Timer = $JumpBufferTimer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var SPEED: float = 100.0
@export var ACCELERATION: float = 10.0
@export var FRICTION: float = 8.0
@export var JUMP_VELOCITY: float = -300.0
@export var FALL_FASTER: float = 1.2
@export var JUMP_CUT: float = 5.0
@export var COYOTE_TIME: float = 0.1
@export var JUMP_BUFFER: float = 0.1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta: float):
	handle_gravity(delta)
	handle_jump()
	var direction: float = get_direction()
	handle_animations(direction)
	apply_movement(direction)


func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		if not is_jumping():  # If the character is falling, fall faster.
			velocity.y += gravity * delta * FALL_FASTER
		else:
			velocity.y += gravity * delta


func handle_jump() -> void:
	if Input.is_action_just_released("jump") and is_jumping():
		Debug.jump_cut.emit()
		velocity.y /= JUMP_CUT

	# Jump buffer
	if Input.is_action_just_pressed("jump") and not is_on_floor():
		jump_buffer_timer.start(JUMP_BUFFER)

	if (Input.is_action_just_pressed("jump") or jump_buffer_timer.time_left) and can_jump():
		if coyote_timer.time_left > 0:
			Debug.jump_coyoteyed.emit()
		elif jump_buffer_timer.time_left:
			Debug.jump_buffered.emit()
		velocity.y = JUMP_VELOCITY
		jump_buffer_timer.stop()


func get_direction() -> float:
	# Get the input direction: -1, 0, 1
	return Input.get_axis("move_left", "move_right")


func handle_animations(direction: float) -> void:
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


func apply_movement(direction: float) -> void:
	if direction:  # We're moving
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION)
	else:  # We're stopping
		velocity.x = move_toward(velocity.x, 0, FRICTION)

	var was_on_floor: bool = is_on_floor()
	move_and_slide()
	if was_on_floor and not is_on_floor() and not is_jumping():
		coyote_timer.start(COYOTE_TIME)


func is_jumping() -> bool:
	return velocity.y < 0


func can_jump() -> bool:
	return is_on_floor() or coyote_timer.time_left > 0
