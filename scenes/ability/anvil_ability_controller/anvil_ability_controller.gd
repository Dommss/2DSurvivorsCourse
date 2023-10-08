extends Node

var base_range = 100
var base_damage = 18
var additional_damage_percent = 1
var base_wait_time

@export var anvil_ability_scene: PackedScene


func _ready():
	base_wait_time = $Timer.wait_time
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	

func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_position = player.global_position + (direction * randf_range(0, base_range))



	var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1)
	var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)
	if !result.is_empty():
		spawn_position = result["position"]
		
	var anvil_ability = anvil_ability_scene.instantiate()
	get_tree().get_first_node_in_group("foreground_layer").add_child(anvil_ability)
	anvil_ability.global_position = spawn_position
	anvil_ability.hitbox_component.damage = base_damage * additional_damage_percent


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "anvil_rate":
		var percent_reduction = current_upgrades["anvil_rate"]["quantity"] * .1
		$Timer.wait_time = base_wait_time * (1 - percent_reduction)
		$Timer.start()
	elif upgrade.id == "anvil_damage":
		additional_damage_percent = 1 + (current_upgrades["anvil_damage"]["quantity"] * .1)
		
