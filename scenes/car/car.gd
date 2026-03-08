extends CharacterBody3D


const SPEED = 400
const ACCELERATION = 1
const DECELERATION = 3
const CAMERA_LATENCY = 50

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$Neck.top_level = true

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			$Neck.rotate_y(-event.relative.x * 0.005)
			$Neck/XPivot.rotate_x(+event.relative.y * 0.005)
			$Neck.rotation.y = clamp($Neck.rotation.y, deg_to_rad(-30), deg_to_rad(30))
			$Neck/XPivot.rotation.x = clamp($Neck/XPivot.rotation.x, deg_to_rad(-5), deg_to_rad(5))

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("accelerate"):
		velocity.z = lerp(velocity.z, SPEED * delta, ACCELERATION * delta)
	else:
		velocity.z = lerp(velocity.z, 0.0, DECELERATION * delta)
	
	$EngineSFX.volume_linear = 0.8*velocity.z/(SPEED*delta)
	
	move_and_slide()

	$Neck.global_position = lerp($Neck.global_position, $CameraIdlePos.global_position, CAMERA_LATENCY * delta)
