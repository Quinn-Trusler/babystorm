extends Node2D


@onready var fire_boss_state_machine: Node = $FireBossStateMachine

@export var speed: float = 200.0

# Hover area
@export var area_center: Vector2 = Vector2(0, -200)
@export var area_size: Vector2 = Vector2(200, 200)

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
