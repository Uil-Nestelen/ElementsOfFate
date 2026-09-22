class_name EncounterType
extends RefCounted

## Defines the encounter types used by the encounter-map system.
##
## The seven normal encounter types can be generated on normal levels.
## BOSS is reserved for the final boss node of a floor.

enum Type {
	COMBAT,
	ELITE,
	SHRINE,
	SHOP,
	EVENT,
	REST,
	MYSTERY,
	TREASURE,
	TRAP,
	BOSS,
}

## Returns whether the type can be generated as a normal encounter.
static func is_normal(type: Type) -> bool:
	return type != Type.BOSS

## Returns whether the type represents a boss encounter.
static func is_boss(type: Type) -> bool:
	return type == Type.BOSS
