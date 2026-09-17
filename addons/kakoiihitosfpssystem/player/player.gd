extends CharacterBody3D

const SPEED = 5.0
const SPRINT_SPEED = 2.5
const AIR_DRAG = 100.0
const JUMP_VELOCITY = 3.0
const LEAN_ANGLES: Array[float] = [-15.0, 15.0]
const LEAN_SPEED = 1.0
const PUSH_FORCE = 0.5
const DEFAULT_FOV = 75 

var Camera_Sensitivity = 0.005
var zoom_fov: float

var is_sprinting: bool
var stamina = 10.0

@export var camera: Camera3D
@export var movement_detection_rays: Array[RayCast3D]
@export var melee_weapon: PackedScene

var inventory: Array[PackedScene]

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	zoom_fov = camera.fov/2

func _physics_process(delta: float) -> void:

	gravity(delta)
	body_movement(SPEED, AIR_DRAG, JUMP_VELOCITY, delta, SPRINT_SPEED)
	physics_pushing(PUSH_FORCE)
	gun_swap(inventory, melee_weapon)
	lean_movement(LEAN_ANGLES, self, movement_detection_rays, delta, LEAN_SPEED)
	
	if Input.is_action_pressed("Zoom"):
		camera.fov = zoom_fov
	else: camera.fov = DEFAULT_FOV
	
func _unhandled_input(event: InputEvent) -> void: # Camera Movement
	
	# Unfocus mouse
	if Input.is_action_pressed("Exit"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	# Refocus mouse
	if Input.is_action_just_pressed("Shoot") and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		# Left/Right
		rotate_y(-event.relative.x * Camera_Sensitivity)
		# Up/Down
		camera.rotate_x(-event.relative.y * Camera_Sensitivity)
		# Clamp to prevent odd camera movements
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-85), deg_to_rad(90))

func gravity(delta: float):
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
func body_movement(speed: float, air_drag: float, jump_speed: float, delta: float, slow_walk_speed: float):
	
	# Jump
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jump_speed
	
	# Walking Movement
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
	if direction:
		# Slow Walk Movement
		if Input.is_action_pressed("Slow Walk"):
			velocity.x = direction.x * slow_walk_speed
			velocity.z = direction.z * slow_walk_speed
		else:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	# Air Drag
	if !is_on_floor():
		velocity.x = move_toward(velocity.x, 0, air_drag * delta)
		velocity.z = move_toward(velocity.z, 0, air_drag * delta)
		
	move_and_slide()
	
func gun_swap(inv: Array[PackedScene], melee: PackedScene):
	
	var slots = ["Slot 1", "Slot 2"]
		
	# Regular Gun Swap
	for i in range(slots.size()):
		if Input.is_action_just_pressed(slots[i]):
			if i < inv.size():
				var slot_number = i
				var gun_instance = inv[i].instantiate()
				if camera.get_child(0) != null:
					camera.get_child(0).queue_free()
				camera.add_child(gun_instance)
	
	# Melee Swap
	if Input.is_action_just_pressed("Melee Slot"):
		if melee != null:
			var melee_instance = melee.instantiate()
			if camera.get_child(0) != null:
				camera.get_child(0).queue_free()
			camera.add_child(melee_instance)
	
func lean_movement(lean_angles: Array[float], lean_object: Node3D, rays: Array[RayCast3D], delta: float, lean_speed: float):
	var target_angle = 0.0

	for i in rays.size():
		if rays[i].is_colliding():
			var collider = rays[i].get_collider()
			if collider.is_in_group("Wall"):
				target_angle = deg_to_rad(lean_angles[i])
			break

	lean_object.rotation.z = move_toward(rotation.z, target_angle, lean_speed * delta)

func physics_pushing(push_force: float):
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider is RigidBody3D:
			var push_direction = -collision.get_normal()
			collider.apply_impulse(push_direction * push_force, collision.get_position() - collider.global_position)
