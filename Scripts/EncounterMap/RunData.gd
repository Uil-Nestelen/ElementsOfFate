class_name RunData
extends RefCounted

const FLOOR_COUNT: int = 5

var master_seed: int
var floors: Array[EncounterMap] = []

func _init(run_seed: int) -> void:
	master_seed = run_seed

	var rng := RandomNumberGenerator.new()
	rng.seed = master_seed

	for floor_number in range(1, FLOOR_COUNT + 1):
		var floor_seed := rng.randi()
		var floor_map := EncounterGenerator.generate_floor(
			floor_number,
			floor_seed
		)

		floors.append(floor_map)
