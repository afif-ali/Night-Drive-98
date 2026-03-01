extends Node3D



func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			$Neck.rotate_y(-event.relative.x * 0.005)
			$Neck/Camera3D.rotate_x(+event.relative.y * 0.005)
			$Neck.rotation.y = clamp($Neck.rotation.y, deg_to_rad(-25), deg_to_rad(25))
			$Neck/Camera3D.rotation.x = clamp($Neck/Camera3D.rotation.x, deg_to_rad(-5), deg_to_rad(5))

func _process(delta: float) -> void:
	pass
