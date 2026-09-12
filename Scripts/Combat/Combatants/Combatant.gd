class_name Combatant
extends Node2D

var grid_coordinate: Vector2i
var max_health: int = 100
var health: int = 100

func set_grid_coordinate(new_coordinate: Vector2i) -> void:
	grid_coordinate = new_coordinate
