class_name GridTile
extends Node2D

var coordinate: Vector2i
var occupant: Node = null
var tile_size: float = 140.0
var path_highlighted: bool = false


func setup(new_coordinate: Vector2i, new_tile_size: float) -> void:
	coordinate = new_coordinate
	tile_size = new_tile_size
	queue_redraw()


func _draw() -> void:
	var rect := Rect2(Vector2.ZERO, Vector2.ONE * tile_size)

	draw_rect(rect, Color("1b2330"), true)
	draw_rect(rect, Color("465467"), false, 2.0)

	if path_highlighted:
		draw_rect(
			rect,
			Color("4caf50", 0.45),
			true
		)

	draw_line(
		Vector2(1.0, tile_size - 1.0),
		Vector2(tile_size - 1.0, tile_size - 1.0),
		Color("263140"),
		1.0
	)

func set_path_highlighted(highlighted: bool) -> void:
	path_highlighted = highlighted
	queue_redraw()
