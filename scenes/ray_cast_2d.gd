extends RayCast2D


var collision_point: Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	target_position = get_local_mouse_position()
	if is_colliding():
		collision_point = get_collision_point()
	else:
		collision_point = Vector2.ZERO
