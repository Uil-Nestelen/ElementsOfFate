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

const ENCOUNTER_WEIGHTS := {
	EncounterType.Type.COMBAT: 40,
	EncounterType.Type.ELITE: 10,
	EncounterType.Type.SHRINE: 10,
	EncounterType.Type.SHOP: 10,
	EncounterType.Type.EVENT: 10,
	EncounterType.Type.REST: 10,
	EncounterType.Type.MYSTERY: 10,
}
