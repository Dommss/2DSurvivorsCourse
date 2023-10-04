extends Node

signal experience_crab_juice_collected(number: float)

func emit_crab_juice_exp_collected(number: float):
	experience_crab_juice_collected.emit(number)
