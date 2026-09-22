extends Node

func _ready() -> void:
	for map_seed in range(1, 1001):
		var map := EncounterGenerator.generate_floor(1, map_seed)

		print(
			"Seed: ",
			map_seed,
			" | Nodes: ",
			map.nodes.size()
		)
