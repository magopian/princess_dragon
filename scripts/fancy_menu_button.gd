class_name FancyMenuButton extends Button

@onready var audio_stream_player_2d: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
@onready var initial_scale: Vector2
@export var scale_to: Vector2 = Vector2(1.01, 1.01)


func _ready() -> void:
	focus_entered.connect(playSound)
	mouse_entered.connect(playSound)
	audio_stream_player_2d.stream = load("res://assets/sounds/temp/drop_003.ogg")
	audio_stream_player_2d.bus = "Sounds"
	add_child(audio_stream_player_2d)
	initial_scale = scale
	pivot_offset = size / 2  # Center the pivot so the scaling is centered.


func playSound():
	audio_stream_player_2d.play()
	var tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(self, "scale", scale_to, 0.1)
	tween.tween_property(self, "scale", initial_scale, 0.1)


func unlock(is_unlocked: bool) -> void:
	%LockedContainer.visible = not is_unlocked
	%ScoreContainer.visible = is_unlocked
	disabled = not is_unlocked
