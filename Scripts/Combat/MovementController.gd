class_name MovementController
extends Node

var grid_manager: GridManager


func calculate_path(
	start_coordinate: Vector2i,
	target_coordinate: Vector2i
) -> Array[Vector2i]:
	var path: Array[Vector2i] = []
	var current := start_coordinate

	while current.x != target_coordinate.x:
		if current.x < target_coordinate.x:
			current.x += 1
		else:
			current.x -= 1

		path.append(current)

	while current.y != target_coordinate.y:
		if current.y < target_coordinate.y:
			current.y += 1
		else:
			current.y -= 1

		path.append(current)

	return path


func update_path_preview(
	start_coordinate: Vector2i,
	target_coordinate: Vector2i
) -> void:
	clear_path_preview()

	var path := calculate_path(
		start_coordinate,
		target_coordinate
	)

	for coordinate in path:
		var tile := grid_manager.get_tile(coordinate)

		if tile != null:
			tile.set_path_highlighted(true)


func clear_path_preview() -> void:
	for coordinate in grid_manager.tiles:
		var tile: GridTile = grid_manager.tiles[coordinate]
		tile.set_path_highlighted(false)
