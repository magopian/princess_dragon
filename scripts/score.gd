extends Control

@onready var label_score: Label = %LabelScore
@onready var coin_sprite: TextureRect = %CoinSprite


func _ready() -> void:
	GameManager.new_score.connect(_on_new_score)
	GameManager.show_score_ui.connect(_on_show_score_ui)


func _process(_delta: float) -> void:
	label_score.text = str(GameManager.get_total_score())


func _on_show_score_ui() -> void:
	# Display the score label!
	if not is_visible_in_tree():
		return
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2.ZERO, 1).set_trans(Tween.TRANS_BOUNCE)


func _on_new_score(score: int, coin: Area2D) -> void:
	if not is_inside_tree():
		return
	label_score.text = str(score)
	# Animate the score label
	var tween: Tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_SPRING)
	tween.tween_property(label_score, "scale", Vector2(1.1, 1.1), 0.05)
	tween.tween_property(label_score, "scale", Vector2(1, 1), 0.05)

	# Use call_deferred because we're going to reparent a node that's already animated.
	call_deferred("animate_coin", coin)


func animate_coin(coin):
	"""Animate the coin: shoot it to the top left score counter
	
	To avoid complicated position transformations, we'll reparent the coin in the same
	canvas layer as the score counter.
	"""
	# Save the coin origin position relative to the viewport. We want this because
	# the score counter is in a canvas layer at position (0, 0) in the viewport.
	var coin_origin_position: Vector2 = coin.get_global_transform_with_canvas().origin
	coin.reparent(self)  # reparent the coin to the current score layer.
	coin.global_position = coin_origin_position  # reposition the coin to its position relative to the viewport.
	coin.scale *= 0.8
	coin.modulate.a = 0.6
	coin.z_index = -1  # We want the coin to disappear behind the coin sprite in the score counter.
	var coin_sprite_center: Vector2 = coin_sprite.global_position + coin_sprite.size / 2
	var tween_coin: Tween = coin.create_tween()  # Create a tween on the node so it's bound to it.
	tween_coin.set_trans(Tween.TRANS_CUBIC)
	tween_coin.set_ease(Tween.EASE_IN_OUT)
	tween_coin.tween_property(coin, "position", coin_sprite_center, 0.5)

	# The following animates the coin sprite to "inflate" when it "receives" a coin.
	# This animation is delayed 0.4 seconds out of a 0.5 travel time for the coin, which
	# seems about right.
	var tween_coin_sprite: Tween = get_tree().create_tween()
	tween_coin_sprite.set_trans(Tween.TRANS_SPRING)
	tween_coin_sprite.tween_interval(0.4)
	tween_coin_sprite.tween_property(coin_sprite, "scale", Vector2(1.1, 1.1), 0.05)
	tween_coin_sprite.tween_property(coin_sprite, "scale", Vector2(1.0, 1.0), 0.05)
	await tween_coin.finished
	coin.queue_free()
