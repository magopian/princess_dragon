extends Line2D

@export var TRAIL_LENGTH: int = 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	add_point(get_parent().position)
	while get_point_count() >= TRAIL_LENGTH:
		remove_point(0)
