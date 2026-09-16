class_name MovementController
extends Node

var grid_manager: GridManager
var player: Player
var turn_manager: TurnManager

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
	target_coordinate: Vector2i,
	movement_points: int
) -> void:
	clear_path_preview()

	var path := calculate_path(
		start_coordinate,
		target_coordinate
	)

	for index in range(path.size()):
		var coordinate := path[index]
		var tile := grid_manager.get_tile(coordinate)

		if tile == null:
			continue

		if index < movement_points:
			tile.set_highlight_state(GridTile.HighlightState.REACHABLE)
		else:
			tile.set_highlight_state(GridTile.HighlightState.UNREACHABLE)

func execute_movement(combatant: Combatant,target_coordinate: Vector2i) -> void:
	if not can_move(combatant):
		return

	var path := calculate_path(combatant.grid_coordinate,target_coordinate)

	var steps_to_take: int = min(path.size(), combatant.movement_points)

	for index in range(steps_to_take):
		var coordinate := path[index]

		if combatant.move_to(coordinate):
			combatant.spend_movement_points(1)
		else:
			break

func clear_path_preview() -> void:
	for coordinate in grid_manager.tiles:
		var tile: GridTile = grid_manager.tiles[coordinate]
		tile.set_highlight_state(
			GridTile.HighlightState.NONE
		)

func can_move(combatant: Combatant) -> bool:
	if turn_manager.current_turn == TurnManager.TurnState.BATTLE_END:
		return false

	if combatant is Player:
		return turn_manager.current_turn == TurnManager.TurnState.PLAYER_TURN

	if combatant is Enemy:
		return turn_manager.current_turn == TurnManager.TurnState.ENEMY_TURN

	return false
