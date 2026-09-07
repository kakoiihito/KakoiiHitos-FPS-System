extends Node3D

@export var drop_gun: PackedScene

@export var area3D: Area3D
var collected: bool

func _process(delta: float) -> void:
	var overlapping_bodies = area3D.get_overlapping_areas()
	for i in overlapping_bodies:
		if i != null:
			if i.is_in_group("Player"):
				i.inventory.append((drop_gun))
				collected = true
	if collected == true:
		queue_free()
