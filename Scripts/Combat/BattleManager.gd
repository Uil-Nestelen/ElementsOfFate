class_name BattleManager
extends Node

enum BattleState {
	NOT_STARTED,
	ACTIVE,
	ENDED
}

signal battle_started
signal battle_ended

var current_state: BattleState = BattleState.NOT_STARTED

var turn_manager: TurnManager
var grid_manager: GridManager
var movement_controller: MovementController

var grid: Node
var player: Node
var enemies: Node

func initialize_battle() -> void:
	_set_state(BattleState.NOT_STARTED)

	turn_manager = TurnManager.new()
	add_child(turn_manager)

	grid_manager = GridManager.new()
	add_child(grid_manager)

	movement_controller = MovementController.new()
	add_child(movement_controller)

	movement_controller.grid_manager = grid_manager

	grid_manager.generate_grid()

	player = Player.new()
	add_child(player)

	player.grid_manager = grid_manager

	player.position = grid_manager.get_tile_global_position(player.grid_coordinate)
	grid_manager.occupy_tile(player.grid_coordinate, player)

	enemies = Node.new()
	enemies.name = "Enemies"
	add_child(enemies)

	var enemy := Enemy.new()
	enemies.add_child(enemy)

	enemy.grid_manager = grid_manager

	enemy.position = grid_manager.get_tile_global_position(enemy.grid_coordinate)
	grid_manager.occupy_tile(enemy.grid_coordinate, enemy)


func start_battle() -> void:
	if current_state != BattleState.NOT_STARTED:
		return

	_set_state(BattleState.ACTIVE)

	turn_manager.start_player_turn()

	battle_started.emit()


func end_battle() -> void:
	if current_state != BattleState.ACTIVE:
		return

	_set_state(BattleState.ENDED)

	turn_manager.end_battle()

	battle_ended.emit()

func _set_state(new_state: BattleState) -> void:
	current_state = new_state
