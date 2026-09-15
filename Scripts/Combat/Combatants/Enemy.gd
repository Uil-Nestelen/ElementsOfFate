class_name Enemy
extends Combatant

var movement_controller: MovementController
var player: Player

func _ready() -> void:
	set_grid_coordinate(Vector2i(3, 1))
	queue_redraw()

func _draw() -> void:
	draw_circle(Vector2.ZERO, 45.0, Color("d94c4c"))

func take_turn() -> void:
	var target := grid_coordinate

	if grid_coordinate.x < player.grid_coordinate.x:
		target.x += 1
	elif grid_coordinate.x > player.grid_coordinate.x:
		target.x -= 1
	elif grid_coordinate.y < player.grid_coordinate.y:
		target.y += 1
	elif grid_coordinate.y > player.grid_coordinate.y:
		target.y -= 1

	movement_controller.execute_movement(self, target)
