extends Node

func _ready() -> void:
	var map := EncounterGenerator.generate_floor(1, 1)

	for level in range(1, EncounterRules.BOSS_LEVEL):
		var level_nodes := EncounterGenerator.get_nodes_at_level(
			map.nodes,
			level
		)

		print("Level ", level, ":")

		for node in level_nodes:
			print(
				"  ",
				EncounterType.Type.keys()[node.encounter_type]
			)
