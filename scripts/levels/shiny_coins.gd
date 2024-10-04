extends Node2D

const next_anim: Dictionary = {
	"DragonFlyIn": "PrincessYeah",
	"PrincessYeah": "DragonLaugh",
	"DragonLaugh": "PrincessPoorVillagers",
	"PrincessPoorVillagers": "DragonSorry",
	"DragonSorry": "PrincessNotHappy",
	"PrincessNotHappy": "DragonHungry",
	"DragonHungry": "PrincessHeresTheCoin",
	"PrincessHeresTheCoin": "DragonYummy",
	"DragonYummy": "PrincessGetsJump",
	"PrincessGetsJump": "DragonBringMoreCoins",
	"DragonBringMoreCoins": "DragonFlyOut",
}

var current_anim: String = "DragonFlyIn"


func _ready() -> void:
	%CutsceneContent.hide()
	GameManager.add_point.connect(_on_coin_picked_up)


func _on_coin_picked_up(_coin: Area2D) -> void:
	if not is_inside_tree():
		return
	GameManager.add_point.disconnect(_on_coin_picked_up)

	Engine.time_scale = 0.2
	await get_tree().create_timer(0.4).timeout
	Engine.time_scale = 1
	start_cutscene()


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
	GameManager.cutscene_finished.connect(_on_cutscene_finished)
	%NinePatchRect.hide()
	%TutoCoinsLabel.hide()
	%CutsceneContent.show()
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
	$Player/AnimatedSprite2D.play("idle")
	$Player.set_physics_process(true)
	%NinePatchRect.show()
	GameManager.pause_menu_enabled.emit(true)
	GameManager.level_started.emit()
	# Unlock the JUMP ability
	GameManager.unlock_capability.emit(GameManager.CAPABILITIES.JUMP)


func cutscene_animation_finished(animation: String) -> void:
	current_anim = next_anim.get(animation, "")
	print("current_anim: ", current_anim)
