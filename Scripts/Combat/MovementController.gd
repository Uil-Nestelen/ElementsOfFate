class_name MovementController
extends Node


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
