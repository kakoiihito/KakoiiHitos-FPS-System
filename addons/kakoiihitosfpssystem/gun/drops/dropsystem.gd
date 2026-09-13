extends Area3D

@export var drop_gun: PackedScene
var collected: bool = false
var can_collect: bool = false
var player: CharacterBody3D

func _ready() -> void:
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)
	
func _process(delta: float) -> void:
	if can_collect == true:
		if Input.is_action_just_pressed("Use") and player != null:
			player.inventory.append(drop_gun)
			queue_free()

func on_body_entered(body: CharacterBody3D):
	if body.is_in_group("Player"):
		can_collect = true
		player = body
		
func on_body_exited(body: CharacterBody3D):
	if body.is_in_group("Player"):
		can_collect = false
		player = null
