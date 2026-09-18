class_name EncounterGenerator
extends RefCounted

static func generate_floor(floor_number: int, map_seed: int) -> EncounterMap:
	var map := EncounterMap.new(floor_number, map_seed)
	var rng := RandomNumberGenerator.new()
	rng.seed = map_seed

	for level in range(1, EncounterRules.NORMAL_LEVEL_COUNT + 1):
		var node_count := rng.randi_range(
			EncounterRules.MIN_NODES_PER_LEVEL,
			EncounterRules.MAX_NODES_PER_LEVEL
		)

		for i in range(node_count):
			var node := EncounterNode.new(level, EncounterType.Type.COMBAT)
			map.nodes.append(node)

	var boss_node := EncounterNode.new(
	EncounterRules.BOSS_LEVEL,
	EncounterType.Type.BOSS
	)

	map.nodes.append(boss_node)

	for level in range(1, EncounterRules.BOSS_LEVEL):
		var current_level_nodes := get_nodes_at_level(map.nodes, level)
		var next_level_nodes := get_nodes_at_level(map.nodes, level + 1)

		connect_levels(
			current_level_nodes,
			next_level_nodes,
			rng
		)
	return map

static func connect_nodes(
	source: EncounterNode,
	target: EncounterNode
) -> void:
	if target in source.outgoing_connections:
		return

	source.outgoing_connections.append(target)
	target.incoming_connections.append(source)

static func connect_levels(
	current_level_nodes: Array[EncounterNode],
	next_level_nodes: Array[EncounterNode],
	rng: RandomNumberGenerator
) -> void:

	## function will first check for the 2 → 2 case. If it matches, it handles that pattern and return
	if current_level_nodes.size() == 2 and next_level_nodes.size() == 2:
		connect_nodes(
			current_level_nodes[0],
			next_level_nodes[0]
		)

		connect_nodes(
			current_level_nodes[1],
			next_level_nodes[1]
		)

		if rng.randi_range(0, 1) == 1:
			if rng.randi_range(0, 1) == 0:
				connect_nodes(
					current_level_nodes[0],
					next_level_nodes[1]
				)
			else:
				connect_nodes(
					current_level_nodes[1],
					next_level_nodes[0]
				)
		return

	## function will first check for the 2 → 3 case. If it matches, it handles that pattern and return
	if current_level_nodes.size() == 2 and next_level_nodes.size() == 3:
		connect_nodes(
			current_level_nodes[0],
			next_level_nodes[0]
		)

		connect_nodes(
			current_level_nodes[0],
			next_level_nodes[1]
		)

		connect_nodes(
			current_level_nodes[1],
			next_level_nodes[2]
		)

		return

	## function will first check for the 3 → 2 case. If it matches, it handles that pattern and return
	if current_level_nodes.size() == 3 and next_level_nodes.size() == 2:
		connect_nodes(
			current_level_nodes[0],
			next_level_nodes[0]
		)

		connect_nodes(
			current_level_nodes[1],
			next_level_nodes[1]
		)

		if rng.randi_range(0, 1) == 0:
			connect_nodes(
				current_level_nodes[2],
				next_level_nodes[0]
			)
		else:
			connect_nodes(
				current_level_nodes[2],
				next_level_nodes[1]
			)

		return
	## function will first check for the 3 → 3 case. If it matches, it handles that pattern and return
	if current_level_nodes.size() == 3 and next_level_nodes.size() == 3:
		connect_nodes(
			current_level_nodes[0],
			next_level_nodes[0]
		)

		connect_nodes(
			current_level_nodes[1],
			next_level_nodes[1]
		)

		connect_nodes(
			current_level_nodes[2],
			next_level_nodes[2]
		)

		if rng.randi_range(0, 1) == 0:
			connect_nodes(
				current_level_nodes[0],
				next_level_nodes[1]
			)
		else:
			connect_nodes(
				current_level_nodes[1],
				next_level_nodes[2]
			)

		return


	for next_node in next_level_nodes:
		var source_index := rng.randi_range(0, current_level_nodes.size() - 1)
		var source_node := current_level_nodes[source_index]

		connect_nodes(source_node, next_node)

	for current_node in current_level_nodes:
		if current_node.outgoing_connections.is_empty():
			var target_index := rng.randi_range(0, next_level_nodes.size() - 1)
			var target_node := next_level_nodes[target_index]

			connect_nodes(current_node, target_node)

static func get_nodes_at_level(
	nodes: Array[EncounterNode],
	level: int
) -> Array[EncounterNode]:
	var level_nodes: Array[EncounterNode] = []

	for node in nodes:
		if node.level == level:
			level_nodes.append(node)

	return level_nodes
