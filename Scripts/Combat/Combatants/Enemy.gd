class_name Enemy
extends Combatant

func _ready() -> void:
	set_grid_coordinate(Vector2i(3, 1))
	queue_redraw()

func _draw() -> void:
	draw_circle(Vector2.ZERO, 45.0, Color("d94c4c"))

func take_turn() -> void:
	pass
