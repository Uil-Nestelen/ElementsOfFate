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
			var encounter_type := EncounterRules.roll_encounter_type(
				floor_number,
				level,
				rng
			)

			var node := EncounterNode.new(
				level,
				encounter_type
			)

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

	if not validate_map(map):
		push_error("Generated encounter map failed validation.")
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

static func validate_map(map: EncounterMap) -> bool:
	for level in range(1, EncounterRules.NORMAL_LEVEL_COUNT + 1):
		var level_nodes := get_nodes_at_level(map.nodes, level)

		# Every normal level must contain 2–3 nodes.
		if level_nodes.size() < EncounterRules.MIN_NODES_PER_LEVEL \
		or level_nodes.size() > EncounterRules.MAX_NODES_PER_LEVEL:
			return false

		for node in level_nodes:
			# Every node after level 1 needs an incoming connection.
			if level > 1 and node.incoming_connections.is_empty():
				return false

			# Every normal node needs an outgoing connection.
			if node.outgoing_connections.is_empty():
				return false

			# Outgoing connections must go only to the next level.
			for target in node.outgoing_connections:
				if target.level != level + 1:
					return false

			# Incoming connections must come only from the previous level.
			if level > 1:
				for source in node.incoming_connections:
					if source.level != level - 1:
						return false

			# Check for duplicate outgoing connections.
			for i in range(node.outgoing_connections.size()):
				for j in range(i + 1, node.outgoing_connections.size()):
					if node.outgoing_connections[i] == node.outgoing_connections[j]:
						return false

			# Check for duplicate incoming connections.
			for i in range(node.incoming_connections.size()):
				for j in range(i + 1, node.incoming_connections.size()):
					if node.incoming_connections[i] == node.incoming_connections[j]:
						return false

	# There must be exactly one boss.
	var boss_nodes := get_nodes_at_level(
		map.nodes,
		EncounterRules.BOSS_LEVEL
	)

	if boss_nodes.size() != 1:
		return false

	var boss := boss_nodes[0]

	# Every normal node must eventually be able to reach the boss.
	for node in map.nodes:
		if node.level <= EncounterRules.NORMAL_LEVEL_COUNT:
			if not can_reach_boss(node, boss):
				return false

	# Boss must actually be a boss encounter.
	if boss.encounter_type != EncounterType.Type.BOSS:
		return false

	# Boss must have incoming connections.
	if boss.incoming_connections.is_empty():
		return false

	# Boss must not lead anywhere else.
	if not boss.outgoing_connections.is_empty():
		return false

	# Boss connections must come from level 10.
	for source in boss.incoming_connections:
		if source.level != EncounterRules.BOSS_LEVEL - 1:
			return false

	return true

static func can_reach_boss(
	node: EncounterNode,
	boss: EncounterNode,
	visited: Array[EncounterNode] = []
) -> bool:
	if node == boss:
		return true

	if node in visited:
		return false

	visited.append(node)

	for next_node in node.outgoing_connections:
		if can_reach_boss(next_node, boss, visited):
			return true

	return false
