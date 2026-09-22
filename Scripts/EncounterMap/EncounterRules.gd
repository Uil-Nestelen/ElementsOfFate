class_name EncounterRules
extends RefCounted

const ENCOUNTER_WEIGHTS := {
	EncounterType.Type.COMBAT: 40,
	EncounterType.Type.ELITE: 10,
	EncounterType.Type.SHRINE: 10,
	EncounterType.Type.SHOP: 10,
	EncounterType.Type.EVENT: 10,
	EncounterType.Type.REST: 10,
	EncounterType.Type.MYSTERY: 10,
}

const MYSTERY_WEIGHTS := {
	EncounterType.Type.SHRINE: 10,
	EncounterType.Type.SHOP: 16,
	EncounterType.Type.REST: 15,
	EncounterType.Type.TREASURE: 10,
	EncounterType.Type.COMBAT: 23,
	EncounterType.Type.ELITE: 21,
	EncounterType.Type.TRAP: 5,
}

const NORMAL_LEVEL_COUNT: int = 10
const MIN_NODES_PER_LEVEL: int = 2
const MAX_NODES_PER_LEVEL: int = 3

const BOSS_LEVEL: int = 11

static func elites_allowed(floor_number: int, level: int) -> bool:
	if floor_number == 1 and level <= 3:
		return false

	return true

static func roll_encounter_type(
	floor_number: int,
	level: int,
	rng: RandomNumberGenerator
) -> EncounterType.Type:

	var available_types: Array[EncounterType.Type] = []
	var total_weight: int = 0

	for encounter_type in EncounterRules.ENCOUNTER_WEIGHTS:
		if encounter_type == EncounterType.Type.ELITE:
			if not EncounterRules.elites_allowed(floor_number, level):
				continue

		var weight: int = EncounterRules.ENCOUNTER_WEIGHTS[encounter_type]

		available_types.append(encounter_type)
		total_weight += weight

	var roll := rng.randi_range(1, total_weight)
	var current_weight: int = 0

	for encounter_type in available_types:
		current_weight += EncounterRules.ENCOUNTER_WEIGHTS[encounter_type]

		if roll <= current_weight:
			return encounter_type

	return EncounterType.Type.COMBAT


static func roll_mystery_type(
	floor_number: int,
	level: int,
	rng: RandomNumberGenerator
) -> EncounterType.Type:

	var available_types: Array[EncounterType.Type] = []
	var total_weight: int = 0

	for encounter_type in MYSTERY_WEIGHTS:
		if encounter_type == EncounterType.Type.ELITE:
			if not elites_allowed(floor_number, level):
				continue

		var weight: int = MYSTERY_WEIGHTS[encounter_type]

		available_types.append(encounter_type)
		total_weight += weight

	var roll := rng.randi_range(1, total_weight)
	var current_weight: int = 0

	for encounter_type in available_types:
		current_weight += MYSTERY_WEIGHTS[encounter_type]

		if roll <= current_weight:
			return encounter_type

	return EncounterType.Type.COMBAT
