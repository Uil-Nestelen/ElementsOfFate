extends Node

func _ready() -> void:
	var counts := {
		EncounterType.Type.SHRINE: 0,
		EncounterType.Type.SHOP: 0,
		EncounterType.Type.REST: 0,
		EncounterType.Type.TREASURE: 0,
		EncounterType.Type.COMBAT: 0,
		EncounterType.Type.ELITE: 0,
		EncounterType.Type.TRAP: 0,
	}

	var total_mysteries := 0

	for map_seed in range(1, 1001):
		var map := EncounterGenerator.generate_floor(1, map_seed)

		for node in map.nodes:
			if node.encounter_type != EncounterType.Type.MYSTERY:
				continue

			total_mysteries += 1
			counts[node.hidden_encounter_type] += 1

	print("========== MYSTERY TEST ==========")
	print("Total Mystery encounters: ", total_mysteries)

	for encounter_type in counts:
		var count: int = counts[encounter_type]
		var percentage: float = (
			float(count) / float(total_mysteries)
		) * 100.0

		print(
			EncounterType.Type.keys()[encounter_type],
			": ",
			count,
			" (",
			percentage,
			"%)"
		)

	print("===================================")
