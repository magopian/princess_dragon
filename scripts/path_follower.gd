extends Path2D

@export var speed: float = 60
@onready var proportional_speed: float
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

	# If not, "complete" the path by miroring it.
	if not is_closed_path:
		for i in range(point_count - 1, -1, -1):
			# We "mirror" the curve, so each point needs to be added with the "out" as
			# its "in".
			curve.add_point(
				curve.get_point_position(i), curve.get_point_out(i), curve.get_point_in(i)
			)
	proportional_speed = speed / curve.get_baked_length()


func _process(delta: float) -> void:
	path_2d.progress_ratio += proportional_speed * delta
