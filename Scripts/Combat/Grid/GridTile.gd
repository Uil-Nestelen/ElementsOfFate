class_name GridTile
extends Node2D

var coordinate: Vector2i
var occupant: Node = null
var tile_size: float = 140.0


func setup(new_coordinate: Vector2i, new_tile_size: float) -> void:
	coordinate = new_coordinate
	tile_size = new_tile_size
	queue_redraw()


func _draw() -> void:
	var rect := Rect2(Vector2.ZERO, Vector2.ONE * tile_size)

	# Keep the first visual version deliberately simple. The tile owns its
	# presentation so later we can add highlights, blocked terrain, occupants,
	# movement ranges, and spell targeting without changing GridManager.
	draw_rect(rect, Color("1b2330"), true)
	draw_rect(rect, Color("465467"), false, 2.0)

	# A very subtle inner line helps separate tiles without making the grid
	# visually dominant over the combatants.
	draw_line(
		Vector2(1.0, tile_size - 1.0),
		Vector2(tile_size - 1.0, tile_size - 1.0),
		Color("263140"),
		1.0
	)
