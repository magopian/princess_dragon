class_name NewSavegameButton extends HBoxContainer

signal savegame_name_submitted(name: String)

var current_text: String = ""


func _on_line_edit_text_changed(new_text: String) -> void:
	%Create.disabled = not new_text
	current_text = new_text


func _on_line_edit_text_submitted(new_text: String) -> void:
	if new_text:
		savegame_name_submitted.emit(new_text)


func _on_create_pressed() -> void:
	if current_text:
		savegame_name_submitted.emit(current_text)
