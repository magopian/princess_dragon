class_name Player extends CharacterBody2D

@onready var coyote_timer: Timer = $CoyoteTimer
@onready var jump_buffer_timer: Timer = $JumpBufferTimer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var SPEED: float = 150.0
@export var ACCELERATION: float = 20.0
@export var FRICTION: float = 20.0
@export var JUMP_VELOCITY: float = -300.0
@export var FALL_FASTER: float = 2.2
@export var MAX_FALL_SPEED: float = 800.0
@export var JUMP_CUT: float = 5.0
@export var COYOTE_TIME: float = 0.1
@export var JUMP_BUFFER: float = 0.1
@export var TELEPORT_SPEED: float = 0.2
@export var BOUNCE_VELOCITY: float = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var original_position: Vector2
var asked_to_jump: bool = false


func _ready() -> void:
	original_position = global_position
	GameManager.player_killed.connect(_on_player_killed)


func _physics_process(delta: float) -> void:
	handle_gravity(delta)
	handle_jump()
	var direction: float = get_direction()
	handle_animations(direction)
	apply_movement(direction)
	handle_bounce()


func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		if not is_jumping():  # If the character is falling, fall faster.
			velocity.y += gravity * delta * FALL_FASTER
		else:
			velocity.y += gravity * delta
		velocity.y = clamp(velocity.y, -MAX_FALL_SPEED, MAX_FALL_SPEED)


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
		asked_to_jump = true
		emit_jump_particles()
		$JumpSound.play()
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
		if animated_sprite.animation == "land" and animated_sprite.is_playing():
			return  # Finish playing the "land" animation
		if animated_sprite.animation == "fall":
			animated_sprite.play("land")
			return
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		if velocity.y < 0:  # Going up
			animated_sprite.play("jump")
		else:  # Falling
			animated_sprite.play("fall")


func apply_movement(direction: float) -> void:
	if direction:  # We're moving
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION)
	else:  # We're stopping
		velocity.x = move_toward(velocity.x, 0, FRICTION)

	var was_on_floor: bool = is_on_floor()
	move_and_slide()
	if was_on_floor and not is_on_floor() and not asked_to_jump:
		coyote_timer.start(COYOTE_TIME)
	if not was_on_floor and is_on_floor():
		emit_jump_particles()
		$FallSound.play()
	asked_to_jump = false


func handle_bounce() -> void:
	for i in get_slide_collision_count():
		var collision: KinematicCollision2D = get_slide_collision(i)
		var collider: Object = collision.get_collider()
		# If the collision is with ground
		if collider == null:
			continue

		# If the collider is with an enemy
		if collision.get_collider().is_in_group("Enemy"):
			var enemy = collision.get_collider()
			# we check that we are hitting it from above.
			if Vector2.UP.dot(collision.get_normal()) > 0.1:
				if enemy.has_method("stun"):
					enemy.stun()
				velocity.y = BOUNCE_VELOCITY
				break  # Prevent further duplicate calls.
			else:
				_on_player_killed(collider)


func is_jumping() -> bool:
	return velocity.y < 0


func can_jump() -> bool:
	return is_on_floor() or coyote_timer.time_left > 0


func _on_player_killed(_body) -> void:
	if not is_inside_tree():
		# Are we the player that's currently in the Scene tree?
		return

	modulate.a = 0.4
	velocity = Vector2.ZERO
	set_physics_process(false)
	# Prevent the player from collecting coins when teleporting back.
	collision_layer = 0

	# Animate the teleport of the player back to the beginning of the level.
	var distance: float = global_position.distance_to(original_position)
	var tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(
		self, "global_position", original_position, distance * TELEPORT_SPEED / 100
	)
	await tween.finished

	modulate.a = 1.0
	set_physics_process(true)
	collision_layer = 2


func emit_jump_particles():
	$JumpParticles.restart()
	$JumpParticles.emitting = true
