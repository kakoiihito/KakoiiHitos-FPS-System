extends Control

enum crosshair_types {STATIC, DYNAMIC}
@export var current_crosshair_type: crosshair_types = crosshair_types.STATIC

@export var color_crosshair: Color = Color.BLACK
@export var length_crosshair: float = 4.0
@export var offset_crosshair: float = 10.0
@export var thickness_crosshair: float = 1.5
@export var dot_crosshair: bool = true

func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _draw() -> void:
	if dot_crosshair == true:
		draw_circle(Vector2(0.0, 0.0), thickness_crosshair, color_crosshair, true)
		
	draw_line(Vector2(0.0, offset_crosshair), Vector2(0.0, length_crosshair if length_crosshair != 0.0 else offset_crosshair), color_crosshair, thickness_crosshair)
	draw_line(Vector2(0.0, -offset_crosshair), Vector2(0.0, -length_crosshair if -length_crosshair != 0.0 else -offset_crosshair), color_crosshair, thickness_crosshair)
	draw_line(Vector2(offset_crosshair, 0.0), Vector2(length_crosshair if length_crosshair != 0.0 else offset_crosshair, 0.0), color_crosshair, thickness_crosshair)
	draw_line(Vector2(-offset_crosshair, 0.0), Vector2(-length_crosshair if -length_crosshair != 0.0 else -offset_crosshair, 0.0), color_crosshair, thickness_crosshair)
