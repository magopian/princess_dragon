extends CanvasLayer


func _ready() -> void:
	var mobile = (
		OS.has_feature("android")
		or OS.has_feature("ios")
		or OS.has_feature("web_android")
		or OS.has_feature("web_ios")
	)
	visible = mobile
