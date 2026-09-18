class_name  EncounterNode
extends RefCounted

var level : int
var encounter_type : EncounterType.Type
var hidden_encounter_type : EncounterType.Type
var incoming_connections : Array[EncounterNode] = []
var outgoing_connections : Array[EncounterNode] = []
var visited : bool = false
var completed : bool = false

func _init(node_level: int, type: EncounterType.Type) -> void:
	level = node_level
	encounter_type = type
