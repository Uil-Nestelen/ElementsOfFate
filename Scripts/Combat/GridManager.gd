class_name GridManager
extends Node


var width: int = 4
var height: int = 3

var tiles: Dictionary = {}


func generate_grid() -> void:
	for y in range(height):
		for x in range(width):
			var coordinate := Vector2i(x, y)

			var tile := GridTile.new()
			tile.coordinate = coordinate

			add_child(tile)

			tiles[coordinate] = tile

	print("Grid generated: ", tiles.size(), " tiles")
	
	for coordinate in tiles:
		print("Tile: ", coordinate)
