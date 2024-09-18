class_name ButtonWithSound extends Button

@onready var audio_stream_player_2d: AudioStreamPlayer2D = AudioStreamPlayer2D.new()


func _ready() -> void:
	focus_entered.connect(playSound)
	mouse_entered.connect(playSound)
	audio_stream_player_2d.stream = load("res://assets/sounds/temp/drop_003.ogg")
	audio_stream_player_2d.bus = "SFX"
	add_child(audio_stream_player_2d)


func playSound():
	audio_stream_player_2d.play()
