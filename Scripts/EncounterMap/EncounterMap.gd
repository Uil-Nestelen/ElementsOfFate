class_name EncounterMap
extends RefCounted

var floor_number: int
var seed: int
var nodes: Array[EncounterNode] = []
var current_node: EncounterNode
var completed: bool = false

func _init(map_floor: int, map_seed: int) -> void:
	floor_number = map_floor
	seed = map_seed
