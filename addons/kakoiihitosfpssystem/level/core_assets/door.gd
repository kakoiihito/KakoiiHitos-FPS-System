extends Node3D

@export var area3d: Area3D
@export var door: RigidBody3D
@export var hinge: HingeJoint3D

@export var locked_on_start: bool

var can_interact: bool
var locked: bool
var interacting_body: CharacterBody3D

func _ready() -> void:
	area3d.body_entered.connect(on_body_entered)
	area3d.body_exited.connect(on_body_exit)
	
	if locked_on_start == true:
		locked = true
		hinge.set_param(HingeJoint3D.PARAM_LIMIT_UPPER, 0.0)
		hinge.set_param(HingeJoint3D.PARAM_LIMIT_LOWER, 0.0)
		
func _process(delta: float) -> void:
	if can_interact and Input.is_action_just_pressed("Use"):
		
		if locked == true:
			locked = false
			
		if locked == false:
			hinge.set_param(HingeJoint3D.PARAM_LIMIT_UPPER, 90.0)
			hinge.set_param(HingeJoint3D.PARAM_LIMIT_LOWER, -90.0)

func on_body_entered(body: CharacterBody3D) -> void:
	can_interact = true
	interacting_body = body

func on_body_exit(body: CharacterBody3D) -> void:
	can_interact = false
	interacting_body = null
