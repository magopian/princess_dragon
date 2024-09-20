extends Control

@onready var savegame_button: PackedScene = preload("res://scenes/savegame_button.tscn")
@onready var new_savegame_button: PackedScene = preload("res://scenes/new_savegame_button.tscn")

var deleting_savegame_button: SavegameButton
var first_time: bool = true
var current_selected_savegame: String


func _ready() -> void:
	current_selected_savegame = GameManager.user_prefs.savegame_file
	var files: PackedStringArray = list_files_in_directory("user://savegames")
	print("save files: ", files)
	for file in files:
		create_savegame_button(file)
	if %Savegames.get_child_count() == 0:
		add_new_save()
		return
	if not current_selected_savegame:
		%Savegames.get_child(0).get_node("%Name").grab_focus()
	first_time = not GameManager.user_prefs.savegame_file


func add_new_save() -> void:
	var new_button: NewSavegameButton = new_savegame_button.instantiate()
	new_button.savegame_name_submitted.connect(_on_new_save)
	%Savegames.add_child(new_button)
	new_button.get_node("%LineEdit").call_deferred("grab_focus")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("menu") and visible:
		get_tree().change_scene_to_file("res://scenes/options_menu.tscn")


func _on_new_save(save_name: String) -> void:
	savegame_selected(save_name)
	# Force the creation of the save file so it appears in the save games selection.
	GameManager.save_score_to_file(save_name)


func list_files_in_directory(path: String) -> PackedStringArray:
	if not DirAccess.dir_exists_absolute(path):
		DirAccess.make_dir_absolute(path)
	return DirAccess.get_files_at(path)


func create_savegame_button(file: String) -> void:
	var button: SavegameButton = savegame_button.instantiate()
	var savegame_name: String = file.replace(".save", "")
	button.get_node("%Name").text = savegame_name
	button.get_node("%Name").pressed.connect(savegame_selected.bind(savegame_name))
	button.get_node("%Delete").pressed.connect(savegame_deleted.bind(button))
	%Savegames.add_child(button)
	if savegame_name == current_selected_savegame:
		button.get_node("%Name").grab_focus()


func savegame_selected(savegame_name: String) -> void:
	GameManager.savegame_selected.emit(savegame_name)
	if first_time:
		# Go straight to the game
		get_tree().change_scene_to_file("res://scenes/game.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/options_menu.tscn")


func savegame_deleted(button: SavegameButton) -> void:
	deleting_savegame_button = button
	%ConfirmDeleteSave.show()


func _on_confirm_delete_save_canceled() -> void:
	deleting_savegame_button = null


func _on_confirm_delete_save_confirmed() -> void:
	deleting_savegame_button.queue_free()
	%AddSavegame.grab_focus()
	GameManager.savegame_deleted.emit(deleting_savegame_button.get_node("%Name").text)


func _on_add_savegame_pressed() -> void:
	add_new_save()
