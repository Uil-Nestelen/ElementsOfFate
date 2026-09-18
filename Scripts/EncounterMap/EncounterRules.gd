class_name EncounterRules
extends RefCounted

const NORMAL_LEVEL_COUNT: int = 10
const MIN_NODES_PER_LEVEL: int = 2
const MAX_NODES_PER_LEVEL: int = 3

const BOSS_LEVEL: int = 11

static func elites_allowed(floor_number: int, level: int) -> bool:
	if floor_number == 1 and level <= 3:
		return false

	return true
