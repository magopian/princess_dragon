extends Control

const horizontal_alignment = {
	"Left": HORIZONTAL_ALIGNMENT_LEFT,
	"Center": HORIZONTAL_ALIGNMENT_CENTER,
	"Right": HORIZONTAL_ALIGNMENT_RIGHT
}


func _ready() -> void:
	visible = true


func fade_in() -> void:
	%AnimationPlayer.play("start")


func fade_out() -> void:
	hide_text()
	%AnimationPlayer.play("stop")
	await %AnimationPlayer.animation_finished
	GameManager.cutscene_finished.emit()


func display_text(speaker: String, horiz_align: String, text: String) -> void:
	%Speaker.text = speaker
	var halign: int = horizontal_alignment.get(horiz_align, HORIZONTAL_ALIGNMENT_LEFT)
	%Speaker.horizontal_alignment = halign
	%Sentence.horizontal_alignment = halign
	%Sentence.text = text
	%DialogContainer.show()
	%Next.modulate.a = 0


func display_next() -> void:
	%Next.modulate.a = 1


func hide_text() -> void:
	%DialogContainer.hide()
