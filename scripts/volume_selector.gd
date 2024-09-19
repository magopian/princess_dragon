extends HBoxContainer

@export_range(0, 1, 0.1) var volume: float = 0.7
@export var audio_bus: UserPreferences.AUDIO_BUS


func _ready() -> void:
	%Label.text = AudioServer.get_bus_name(audio_bus)
	%Volume.value = GameManager.user_prefs.get_volume_level(audio_bus)
	%Volume.value_changed.connect(_on_value_changed)


func _on_value_changed(value: float) -> void:
	GameManager.volume_preference_changed.emit(audio_bus, value)
