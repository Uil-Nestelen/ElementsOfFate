class_name RunData
extends RefCounted

const FLOOR_COUNT: int = 5

var master_seed: int
var floors: Array[EncounterMap] = []

func _init(run_seed: int) -> void:
	master_seed = run_seed
