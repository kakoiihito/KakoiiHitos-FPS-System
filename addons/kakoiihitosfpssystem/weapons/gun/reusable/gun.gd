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
	if Input.is_action_just_pressed("Reload"):
		reload()
			
func deal_damage():
	var collider = Raycast.get_collider()
	if collider != null:
		if collider.has_method("damage"):
			collider.damage(GunValues.damage)

func reload():
	var needed_ammo = GunValues.max_ammo_per_mag - current_mag_ammo
	var theoretical_ammo_deduction = reserve_ammo - needed_ammo
	if theoretical_ammo_deduction < 0:
		pass
	else:
		current_mag_ammo += needed_ammo
		reserve_ammo -= needed_ammo
