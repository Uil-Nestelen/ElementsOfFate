class_name Player
extends Combatant

func _ready() -> void:
	set_grid_coordinate(Vector2i(0, 1))
	queue_redraw()

func _draw() -> void:
	draw_circle(Vector2.ZERO, 45.0, Color("4f8cff"))
