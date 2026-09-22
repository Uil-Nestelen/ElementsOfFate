extends Node

## Central coordinator for the current game/run state.
## This is an autoload singleton, so gameplay scenes do not own the global run state.

signal state_changed(previous_state: GameState, new_state: GameState)
signal run_started()

# Major states of the game. RUN represents an active run; MAP and COMBAT are
# concrete phases within that run.
enum GameState {
	MAIN_MENU,
	RUN,
	MAP,
	COMBAT,
}

const SCENE_PATHS := {
	GameState.MAIN_MENU: "res://Scenes/Main/MainMenu.tscn",
	GameState.MAP: "res://Scenes/Main/Map.tscn",
	GameState.COMBAT: "res://Scenes/Main/Combat.tscn",
}

var current_state: GameState = GameState.MAIN_MENU
var run_active: bool = false
var current_run: RunData

func start_new_game(run_seed: int = 0) -> void:
	if run_seed == 0:
		var rng := RandomNumberGenerator.new()
		rng.randomize()
		run_seed = rng.randi()

	current_run = RunData.new(run_seed)

	run_active = true
	run_started.emit()
	_set_state(GameState.RUN)
	_set_state(GameState.MAP)

func enter_combat() -> void:
	if not run_active:
		return
	_set_state(GameState.COMBAT)

func return_to_map() -> void:
	if not run_active:
		return
	_set_state(GameState.MAP)

func return_to_main_menu() -> void:
	run_active = false
	_set_state(GameState.MAIN_MENU)

func _set_state(new_state: GameState) -> void:
	if current_state == new_state:
		return

	var previous_state := current_state
	current_state = new_state
	state_changed.emit(previous_state, new_state)

	if SCENE_PATHS.has(new_state):
		var scene_path: String = SCENE_PATHS[new_state]
		get_tree().change_scene_to_file(scene_path)
