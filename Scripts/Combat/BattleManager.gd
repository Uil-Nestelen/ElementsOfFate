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

var grid: Node
var player: Node
var enemies: Node

func initialize_battle() -> void:
	current_state = BattleState.NOT_STARTED

	turn_manager = TurnManager.new()
	add_child(turn_manager)


func start_battle() -> void:
	if current_state != BattleState.NOT_STARTED:
		return

	current_state = BattleState.ACTIVE

	turn_manager.start_player_turn()

	battle_started.emit()


func end_battle() -> void:
	if current_state != BattleState.ACTIVE:
		return

	current_state = BattleState.ENDED

	turn_manager.end_battle()

	battle_ended.emit()

func _set_state(new_state: BattleState) -> void:
	current_state = new_state
