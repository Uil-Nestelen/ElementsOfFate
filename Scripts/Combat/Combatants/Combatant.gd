class_name Combatant
extends Node2D

var grid_manager: GridManager

var grid_coordinate: Vector2i
var max_health: int = 100
var health: int = 100

var max_movement_points: int = 3
var movement_points: int = 3


func set_grid_coordinate(new_coordinate: Vector2i) -> void:
	grid_coordinate = new_coordinate


func reset_movement_points() -> void:
	movement_points = max_movement_points


func spend_movement_points(amount: int) -> bool:
	if amount < 0:
		return false

	if movement_points < amount:
		return false

	movement_points -= amount
	return true


func has_movement_points(amount: int) -> bool:
	return movement_points >= amount


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
