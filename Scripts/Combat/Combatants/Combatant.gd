class_name Combatant
extends Node2D

var grid_manager: GridManager

var grid_coordinate: Vector2i
var max_health: int = 100
var health: int = 100

func set_grid_coordinate(new_coordinate: Vector2i) -> void:
	grid_coordinate = new_coordinate

func move_to(new_coordinate: Vector2i) -> bool:
	var success := grid_manager.move_occupant(
		self,
		grid_coordinate,
		new_coordinate
	)

	if not success:
		return false

	grid_coordinate = new_coordinate
	position = grid_manager.get_tile_global_position(new_coordinate)

	return true
