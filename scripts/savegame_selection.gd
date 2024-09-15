extends Control

@onready var savegame_button: PackedScene = preload("res://scenes/savegame_button.tscn")


func _ready() -> void:
	var files: PackedStringArray = list_files_in_directory("user://savegames")
	print("save files: ", files)
	for file in files:
		create_savegame_button(file)
	if %Savegames.get_child_count() == 0:
		add_new_save()
		return
	%Savegames.get_child(0).get_node("%Name").grab_focus()


func add_new_save() -> void:
	var line_edit: LineEdit = LineEdit.new()
	line_edit.text = "save game 1"
	line_edit.text_submitted.connect(_on_new_save)
	%Savegames.add_child(line_edit)
	line_edit.grab_focus()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("menu") and visible:
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_new_save(save_name: String) -> void:
	savegame_selected(save_name)


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


func savegame_selected(savegame_name: String) -> void:
	GameManager.savegame_selected.emit(savegame_name)
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func savegame_deleted(button: SavegameButton) -> void:
	var savegame_name: String = button.get_node("%Name").text
	button.queue_free()
	GameManager.savegame_deleted.emit(savegame_name)


func _on_add_savegame_pressed() -> void:
	add_new_save()
