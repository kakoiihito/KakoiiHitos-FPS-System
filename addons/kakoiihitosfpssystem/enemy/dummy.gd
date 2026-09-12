extends Node3D

var health: float
@export var default_health: float = 100.0

func _ready() -> void:
	health = default_health

func _process(delta: float) -> void:
	if health <= 0:
		dead()

func damage(damage_dealt: float):
	health -= damage_dealt
	
func dead():
	queue_free()
