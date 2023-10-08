extends Node
class_name HealthComponent

signal died
signal health_changed
signal health_decreased

@export var max_health: float = 10
@export var should_use_meta: bool

var current_health
var meta_health = MetaProgression.get_upgrade_count("health_increase")
var adjusted_max_health = max_health + meta_health

func _ready():
	if should_use_meta:
		current_health = adjusted_max_health
	else:
		current_health = max_health



func damage(damage_amount: float):
	current_health = clamp(current_health - damage_amount, 0, adjusted_max_health)
	health_changed.emit()
	if damage_amount > 0:
		health_decreased.emit()
	Callable(check_death).call_deferred()	


func heal(heal_amount: int):
	damage(-heal_amount)


func get_health_percent():
	if adjusted_max_health <= 0:
		return 0
	return min(current_health / adjusted_max_health, 1)


func check_death():	
	if current_health == 0:
		died.emit()
		owner.queue_free()
