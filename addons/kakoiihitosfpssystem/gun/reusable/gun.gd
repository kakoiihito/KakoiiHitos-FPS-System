extends Node3D

@export var GunValues: GunData
@export var Raycast: RayCast3D

var reserve_ammo: int
var current_mag_ammo: int

func _ready() -> void:
	current_mag_ammo = GunValues.max_ammo_per_mag
	reserve_ammo = GunValues.starting_reserve_ammo

func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("Shoot"):
		if current_mag_ammo != 0:
			deal_damage()
			current_mag_ammo -= 1
			print(Raycast.get_collider())
	
func deal_damage():
	var collider = Raycast.get_collider()
	if collider != null:
		if collider.has_method("damage"):
			collider.damage(GunValues.damage)
