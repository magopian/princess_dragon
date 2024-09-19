class_name UserPreferences extends Resource

enum AUDIO_BUS { MASTER, MUSIC, SOUNDS }
@export var muted: bool = false
@export var volume_levels: Dictionary = {
	AUDIO_BUS.MASTER: 0.7,
	AUDIO_BUS.MUSIC: 0.7,
	AUDIO_BUS.SOUNDS: 0.7,
}


func save() -> void:
	ResourceSaver.save(self, "user://user_preferences.tres")
	apply_preferences()


func set_muted(new_muted: bool) -> void:
	muted = new_muted
	save()


func get_volume_level(audio_bus: AUDIO_BUS) -> float:
	return volume_levels[audio_bus]


func set_volume_level(audio_bus: AUDIO_BUS, volume_level: float):
	volume_levels[audio_bus] = volume_level
	save()


func apply_preferences() -> void:
	print("applying preferences")
	AudioServer.set_bus_mute(AUDIO_BUS.MASTER, muted)
	for audio_bus in range(AUDIO_BUS.size()):
		var volume_level: float = get_volume_level(audio_bus)
		AudioServer.set_bus_volume_db(audio_bus, linear_to_db(volume_level))


static func load_or_create() -> UserPreferences:
	var res: UserPreferences = load("user://user_preferences.tres") as UserPreferences
	if !res:
		res = UserPreferences.new()
	return res
