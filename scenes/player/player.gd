extends CharacterBody3D


const SPEED = 300
const GRAVITY = 9.8
const SENSITIVITY = 0.008


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			rotate_y(-event.relative.x * SENSITIVITY)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= GRAVITY * delta

	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED * delta
		velocity.z = direction.z * SPEED * delta
	else:
		velocity.x = 0
		velocity.z = 0

	move_and_slide()
