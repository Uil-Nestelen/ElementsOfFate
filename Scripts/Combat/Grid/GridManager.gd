class_name GridManager
extends Node2D

const TILE_SIZE: float = 140.0
const TILE_GAP: float = 4.0

var width: int = 4
var height: int = 3

var tiles: Dictionary = {}


func generate_grid() -> void:
	# The grid is a child of the combat scene, so keep the arena centered in
	# the current 1920x1080 prototype viewport.
	var grid_size := Vector2(
		width * TILE_SIZE + (width - 1) * TILE_GAP,
		height * TILE_SIZE + (height - 1) * TILE_GAP
	)
	position = (Vector2(1920.0, 1080.0) - grid_size) * 0.5

	for y in range(height):
		for x in range(width):
			var coordinate := Vector2i(x, y)

			var tile := GridTile.new()
			tile.setup(coordinate, TILE_SIZE)
			tile.position = Vector2(
				x * (TILE_SIZE + TILE_GAP),
				y * (TILE_SIZE + TILE_GAP)
			)

			add_child(tile)
			tiles[coordinate] = tile

	print("Grid generated: ", tiles.size(), " tiles")

	var test_tile := get_tile(Vector2i(2, 1))
	print("Lookup test: ", test_tile.coordinate)


func get_tile(coordinate: Vector2i) -> GridTile:
	return tiles.get(coordinate)

func occupy_tile(coordinate: Vector2i, occupant: Node) -> bool:
	var tile := get_tile(coordinate)

	if tile == null:
		return false

	if tile.occupant != null:
		return false

	tile.occupant = occupant
	return true


func vacate_tile(coordinate: Vector2i, occupant: Node) -> bool:
	var tile := get_tile(coordinate)

	if tile == null:
		return false

	if tile.occupant != occupant:
		return false

	tile.occupant = null
	return true


func is_tile_occupied(coordinate: Vector2i) -> bool:
	var tile := get_tile(coordinate)

	if tile == null:
		return false

	return tile.occupant != null

func get_tile_global_position(coordinate: Vector2i) -> Vector2:
	var tile := get_tile(coordinate)

	if tile == null:
		return Vector2.ZERO

	return to_global(
		tile.position + Vector2.ONE * (TILE_SIZE * 0.5)
	)

func get_tile_at_global_position(global_position: Vector2) -> GridTile:
	var local_position := to_local(global_position)

	for coordinate in tiles:
		var tile: GridTile = tiles[coordinate]
		var tile_rect := Rect2(
			tile.position,
			Vector2.ONE * TILE_SIZE
		)

		if tile_rect.has_point(local_position):
			return tile

	return null

func move_occupant(occupant: Node, from_coordinate: Vector2i, to_coordinate: Vector2i) -> bool:
	var from_tile := get_tile(from_coordinate)
	var to_tile := get_tile(to_coordinate)

	if from_tile == null or to_tile == null:
		return false

	if from_tile.occupant != occupant:
		return false

	if to_tile.occupant != null:
		return false

	from_tile.occupant = null
	to_tile.occupant = occupant

	return true
