extends Control
signal jump_buffered
signal jump_coyoteyed
signal jump_cut

@export var DEBUG_MOVEMENT: bool = false
@export var DEBUG_PLAYER_KILLED: bool = false


func _ready() -> void:
	if DEBUG_MOVEMENT:
		jump_buffered.connect(_on_jump_buffered)
		jump_coyoteyed.connect(_on_jump_coyoteyed)
		jump_cut.connect(_on_jump_cut)
	if DEBUG_PLAYER_KILLED:
		GameManager.player_killed.connect(_on_player_killed)


func _on_jump_buffered() -> void:
	print("Jump buffered")


func _on_jump_coyoteyed() -> void:
	print("Jump coyoteyed")


func _on_jump_cut() -> void:
	print("Jump cut")


func _on_player_killed(player) -> void:
	print("Player killed")
	var distance: float = player.global_position.distance_to(player.original_position)
	print("distance to teleport: ", distance)
	print("time to teleport: ", distance * player.TELEPORT_SPEED / 100)
