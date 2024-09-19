extends Control


func _ready() -> void:
	var user_prefs: UserPreferences = GameManager.user_prefs
	%Muted.button_pressed = user_prefs.muted
	%Muted.toggled.connect(GameManager.muted_preference_changed.emit)
