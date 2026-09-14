class_name TurnManager
extends Node

enum TurnState {
	PLAYER_TURN,
	ENEMY_TURN,
	BATTLE_END
}

var current_turn: TurnState = TurnState.PLAYER_TURN
signal player_turn_started
signal enemy_turn_started

func start_player_turn() -> void:
	current_turn = TurnState.PLAYER_TURN
	player_turn_started.emit()


func start_enemy_turn() -> void:
	current_turn = TurnState.ENEMY_TURN
	enemy_turn_started.emit()


func end_player_turn() -> void:
	if current_turn != TurnState.PLAYER_TURN:
		return

	start_enemy_turn()


func end_enemy_turn() -> void:
	if current_turn != TurnState.ENEMY_TURN:
		return

	start_player_turn()


func end_battle() -> void:
	current_turn = TurnState.BATTLE_END
