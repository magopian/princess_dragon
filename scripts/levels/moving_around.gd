extends Node2D

const next_anim: Dictionary = {
	"VillagersEnter": "VillagersTerrified",
	"VillagersTerrified": "DragonFlyIn",
	"DragonFlyIn": "DragonFire",
	"DragonFire": "DragonFlyOut",
	"DragonFlyOut": "PrincessOk",
	"PrincessOk": "PrincessHelmet",
	"PrincessHelmet": "PrincessCountOnMe",
	"PrincessCountOnMe": "VillagersLeave",
}

var current_anim: String = "VillagersEnter"


func _ready() -> void:
	start_cutscene()
	GameManager.cutscene_finished.connect(_on_cutscene_finished)


func _process(_delta: float) -> void:
	if not has_node("%CutsceneBorders"):
		return

	if Input.is_action_just_pressed("ui_accept"):
		if current_anim:
			%CutsceneAnim.play(current_anim)
		else:
			quit_cutscene()
	if Input.is_action_pressed("menu"):
		quit_cutscene()


func start_cutscene() -> void:
	%CountDownTimer.queue_free()
	%NinePatchRect.hide()
	%TutoMoveLabel.hide()
	$Player/AnimatedSprite2D.play("idle")
	get_tree().paused = false
	$Player.set_physics_process(false)
	%CutsceneBorders.fade_in()
	GameManager.pause_menu_enabled.emit(false)
	%CutsceneAnim.animation_finished.connect(cutscene_animation_finished)
	%CutsceneAnim.play(current_anim)


func quit_cutscene() -> void:
	if %CutsceneBorders:
		%CutsceneBorders.fade_out()


func _on_cutscene_finished() -> void:
	if not %CutsceneContent:
		return

	%CutsceneContent.queue_free()
	%CutsceneBorders.queue_free()
	%TutoMoveLabel.show()
	$Player/AnimatedSprite2D.play("idle")
	$Player.set_physics_process(true)
	%NinePatchRect.show()
	GameManager.pause_menu_enabled.emit(true)
	GameManager.level_started.emit()
	#TODO: unlock in a further level, after the cutscene with the dragon eating gold
	GameManager.unlock_capability.emit(GameManager.CAPABILITIES.JUMP)


func cutscene_animation_finished(animation: String) -> void:
	current_anim = next_anim.get(animation, "")
	print("current_anim: ", current_anim)
