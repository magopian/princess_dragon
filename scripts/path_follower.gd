extends Path2D

@export var time_to_loop: float = 4
@onready var path_2d: PathFollow2D = $Path2D
@onready var remote_transform_2d: RemoteTransform2D = $Path2D/RemoteTransform2D
@onready var is_closed_path: bool
@onready var direction: float = 1.0


func _ready() -> void:
	# Get the second child, which is the one added to
	# this "PathFollower" scene.
	var object_to_move: Node2D = get_child(1)
	# And set it to be the "remote transformed object"
	remote_transform_2d.remote_path = object_to_move.get_path()

	# Is the path2d a closed path?
	var point_count: int = curve.point_count
	is_closed_path = curve.get_point_position(0) == curve.get_point_position(curve.point_count - 1)

	var tween: Tween = get_tree().create_tween().set_loops()
	if not is_closed_path:
		tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
		tween.tween_property(path_2d, "progress_ratio", 1, time_to_loop / 2)
		tween.tween_property(path_2d, "progress_ratio", 0, time_to_loop / 2)
	else:
		tween.set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(path_2d, "progress_ratio", 1, time_to_loop).as_relative()
