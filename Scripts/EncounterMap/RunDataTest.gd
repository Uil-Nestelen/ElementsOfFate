extends Node

func _ready() -> void:
	var test_seed: int = 123456789

	var run_a := RunData.new(test_seed)
	var run_b := RunData.new(test_seed)

	print("=== Full RunData Determinism Test ===")

	if run_a.floors.size() != RunData.FLOOR_COUNT:
		push_error("Run A does not contain 5 floors.")
		return

	if run_b.floors.size() != RunData.FLOOR_COUNT:
		push_error("Run B does not contain 5 floors.")
		return

	for floor_index in range(RunData.FLOOR_COUNT):
		var floor_a: EncounterMap = run_a.floors[floor_index]
		var floor_b: EncounterMap = run_b.floors[floor_index]

		print("Checking Floor ", floor_index + 1)

		if not compare_floors(floor_a, floor_b):
			push_error(
				"Floor %d is not deterministic!" % (floor_index + 1)
			)
			return

	print("Full RunData determinism test PASSED.")


func compare_floors(
	floor_a: EncounterMap,
	floor_b: EncounterMap
) -> bool:

	if floor_a.seed != floor_b.seed:
		return false

	if floor_a.nodes.size() != floor_b.nodes.size():
		return false

	for node_index in range(floor_a.nodes.size()):
		var node_a: EncounterNode = floor_a.nodes[node_index]
		var node_b: EncounterNode = floor_b.nodes[node_index]

		if node_a.level != node_b.level:
			return false

		if node_a.encounter_type != node_b.encounter_type:
			return false

		if node_a.hidden_encounter_type != node_b.hidden_encounter_type:
			return false

		if node_a.incoming_connections.size() != node_b.incoming_connections.size():
			return false

		if node_a.outgoing_connections.size() != node_b.outgoing_connections.size():
			return false

		for connection_index in range(node_a.incoming_connections.size()):
			var target_a: EncounterNode = node_a.incoming_connections[connection_index]
			var target_b: EncounterNode = node_b.incoming_connections[connection_index]

			if target_a.level != target_b.level:
				return false

			var target_a_index: int = floor_a.nodes.find(target_a)
			var target_b_index: int = floor_b.nodes.find(target_b)

			if target_a_index != target_b_index:
				return false

		for connection_index in range(node_a.outgoing_connections.size()):
			var target_a: EncounterNode = node_a.outgoing_connections[connection_index]
			var target_b: EncounterNode = node_b.outgoing_connections[connection_index]

			var target_a_index: int = floor_a.nodes.find(target_a)
			var target_b_index: int = floor_b.nodes.find(target_b)

			if target_a_index != target_b_index:
				return false

	return true
