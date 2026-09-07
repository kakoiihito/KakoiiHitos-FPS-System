extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 3.0
var CAMERA_SENSITIVITY = 0.025

@export var camera: Camera3D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:

	gravity(delta)
	movement()
	
func _unhandled_input(event: InputEvent) -> void: # Camera Movement
	
	# Unfocus mouse
	if Input.is_action_pressed("Exit"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	# Refocus mouse
	if Input.is_action_just_pressed("Shoot") and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		# Left/Right
		rotate_y(-event.relative.x * CAMERA_SENSITIVITY)
		# Up/Down
		camera.rotate_x(-event.relative.y * CAMERA_SENSITIVITY)
		# Clamp to prevent odd camera movements.
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-85), deg_to_rad(90))

func gravity(delta: float):
	if not is_on_floor():
		velocity += get_gravity() * delta
		
func movement():
	# Jump
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Walking Movement
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	move_and_slide()
	
