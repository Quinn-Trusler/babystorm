extends Node2D

signal on_health_updated(health)

@onready var fire_boss_state_machine: Node = $FireBossStateMachine
@export var health = 100
@export var speed: float = 200.0

# Hover area
@export var area_center: Vector2 = Vector2(0, -60)
@export var area_size: Vector2 = Vector2(400, 80)

@export var arrive_distance: float = 10.0

var target_pos: Vector2


func _ready():
	randomize()
	target_pos = get_random_point()


func _process(delta):
	var to_target = target_pos - global_position
	
	# Pick a new point when close
	if to_target.length() < arrive_distance:
		target_pos = get_random_point()
		return
	
	# Move toward target
	var direction = to_target.normalized()
	global_position += direction * speed * delta
	

func get_random_point() -> Vector2:
	return area_center + Vector2(
		randf_range(-area_size.x / 2, area_size.x / 2),
		randf_range(-area_size.y / 2, area_size.y / 2)
	)


func _on_area_2d_area_entered(area: Area2D) -> void:
	var area_parent = area.get_node("../")
	if area_parent and area_parent is Projectile:
		take_damage(area_parent.damage_amount)
		
func take_damage(damage_amount):
	health -= damage_amount
	on_health_updated.emit(health)
	print(health)
	if health <= 0:
		print("boss has died")
		var player : TheBaby = get_tree().get_first_node_in_group("player")	
		player.swap_body_part("fire secondary")
		queue_free()
		
