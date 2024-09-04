extends Control

@onready var label_score: Label = %LabelScore
@onready var coin_sprite: TextureRect = %CoinSprite


func _ready() -> void:
	GameManager.new_score.connect(_on_new_score)


func _on_new_score(score: int, coin: Area2D) -> void:
	label_score.text = str(score)
	var tween: Tween = get_tree().create_tween()
	# Animate the score label
	tween.tween_property(label_score, "scale", Vector2(1.1, 1.1), 0.05).set_trans(
		Tween.TRANS_SPRING
	)
	tween.tween_property(label_score, "scale", Vector2(1, 1), 0.05).set_trans(Tween.TRANS_SPRING)

	call_deferred("animate_coin", coin)


func animate_coin(coin):
	"""Animate the coin: shoot it to the top left score counter
	
	To avoid complicated position transformations, we'll reparent the coin in the same
	canvas layer as the score counter.
	"""
	# Save the coin origin position relative to the viewport. We want this because
	# the score counter is in a canvas layer at position (0, 0) in the viewport.
	var coin_origin_position = coin.get_global_transform_with_canvas().origin
	coin.reparent(self)  # reparent the coin to the current score layer.
	coin.global_position = coin_origin_position  # reposition the coin to its position relative to the viewport.
	coin.scale *= 0.8
	coin.modulate.a = 0.6
	coin.z_index = -1  # We want the coin to disappear behind the coin sprite in the score counter.
	var tween_coin: Tween = get_tree().create_tween()
	(
		tween_coin
		. tween_property(coin, "position", coin_sprite.global_position + coin_sprite.size / 2, 0.5)
		. set_trans(Tween.TRANS_CUBIC)
		. set_ease(Tween.EASE_IN_OUT)
	)

	# The following animates the coin sprite to "inflate" when it "receives" a coin.
	# This animation is delayed 0.4 seconds out of a 0.5 travel time for the coin, which
	# seems about right.
	var tween_coin_sprite: Tween = get_tree().create_tween()
	tween_coin_sprite.tween_interval(0.4)
	tween_coin_sprite.tween_property(coin_sprite, "scale", Vector2(1.1, 1.1), 0.05).set_trans(
		Tween.TRANS_SPRING
	)

	tween_coin_sprite.tween_property(coin_sprite, "scale", Vector2(1.0, 1.0), 0.05).set_trans(
		Tween.TRANS_SPRING
	)
	await tween_coin.finished
	coin.queue_free()
