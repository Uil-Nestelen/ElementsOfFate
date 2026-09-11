class_name TurnManager
extends Node

enum TurnState {
	PLAYER_TURN,
	ENEMY_TURN,
	BATTLE_END
}

var current_turn: TurnState = TurnState.PLAYER_TURN

func start_player_turn() -> void:
	current_turn = TurnState.PLAYER_TURN
	
func start_enemy_turn() -> void:
	current_turn = TurnState.ENEMY_TURN
	
func end_battle() -> void:
	current_turn = TurnState.BATTLE_END
