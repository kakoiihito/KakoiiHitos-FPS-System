extends RigidBody3D

@export var throw_force: float


func _ready() -> void:
	gravity_scale = 0.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Shoot"):
		gravity_scale = 1.0
		apply_central_impulse(throw_force * -global_transform.basis.z)
		
