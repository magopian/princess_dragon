extends Node

var score = 0

@onready var score_label = $ScoreLabel
@onready var touch_controls = $"../TouchControls"


func _ready():
	var mobile = (
		OS.has_feature("android")
		or OS.has_feature("ios")
		or OS.has_feature("web_android")
		or OS.has_feature("web_ios")
	)
	touch_controls.visible = mobile


func add_point():
	score += 1
	score_label.text = "You collected " + str(score) + " coins."
