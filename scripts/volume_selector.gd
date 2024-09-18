@tool
extends HBoxContainer

@export_range(0, 1, 0.1) var volume: float = 0.7

enum AudioBus {}
@export var audio_bus: AudioBus


func _validate_property(property: Dictionary) -> void:
	"""Get the list of audio buses from the AudioServer, massage it for the export var."""
	if property.name == "audio_bus":
		var options: Array[String] = []
		for i in range(AudioServer.bus_count):
			var bus_name = AudioServer.get_bus_name(i)
			options.append(bus_name)
		var hint_string: String = ",".join(options)
		property.hint_string = hint_string


func _ready() -> void:
	%Label.text = AudioServer.get_bus_name(audio_bus)
	%Volume.value = volume
	%Volume.value_changed.connect(_on_value_changed)


func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(audio_bus, linear_to_db(value))
