extends BabyBodyPart

const FIRE_PROJECTILE = preload("res://Graeme/Scenes/Attacks/fire_projectile.tscn")
const DEFAULT_PROJECTILE_ATTACK = preload("res://Graeme/Scenes/Attacks/default_projectile_attack.tscn")
const ICE_PROJECTILE = preload("res://Graeme/Scenes/Attacks/ice_projectile.tscn")

const DEFAULT_NAME: String = "default secondary"
const FIRE_NAME: String = "fire secondary"
const ICE_NAME: String = "ice secondary"

@onready var the_baby: TheBaby = $".."

@onready var attack_cool_down_timer: Timer = $AttackCoolDownTimer
@onready var attack_spawn_point: Node2D = $AttackSpawnPoint
@onready var secondary_arm_animated_sprite_2d: AnimatedSprite2D = $SecondaryArmAnimatedSprite2D

var can_attack: bool = true
var current_type: String = DEFAULT_NAME
var attack_direction = -1

var right_facing_position: Vector2 = Vector2(-2, 4)
var left_facing_position: Vector2 = Vector2(3, 3)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	the_baby.on_change_direction.connect(change_attack_direction)
	the_baby.on_swapped_body_part.connect(swap_body_part)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func swap_body_part(body_part):
	if body_part == DEFAULT_NAME or body_part == ICE_NAME or body_part == FIRE_NAME:
		current_type = body_part
		
	
func attack():

	if can_attack:
		can_attack = false
		attack_cool_down_timer.start()
		
		if current_type == DEFAULT_NAME:
			#spawn projectile
			var default_projectile_attack_instance = DEFAULT_PROJECTILE_ATTACK.instantiate()
			spawn_projectile(default_projectile_attack_instance)
			default_projectile_attack_instance.set_direction(attack_direction)
			
		if current_type == ICE_NAME:
			var ice_projectile_attack_instance = ICE_PROJECTILE.instantiate()
			spawn_projectile(ice_projectile_attack_instance)
			ice_projectile_attack_instance.set_direction(attack_direction)
		if current_type == FIRE_NAME:
			var fire_projectile_attack_instance = FIRE_PROJECTILE.instantiate()
			spawn_projectile(fire_projectile_attack_instance)
			fire_projectile_attack_instance.set_direction(attack_direction)
			
	secondary_arm_animated_sprite_2d.play("secondaryArmPunch")
		
func spawn_projectile(projectile_attack_instance):
	
	if projectile_attack_instance is DefaultProjectile:
		var projectile: DefaultProjectile = projectile_attack_instance
		projectile.instigator = the_baby
				
	get_tree().current_scene.add_child(projectile_attack_instance)
	projectile_attack_instance.global_position = attack_spawn_point.global_position

func change_attack_direction(direction):
	if direction == 1 and attack_spawn_point.position.x < 0 or direction == -1 and attack_spawn_point.position.x > 0:
		attack_spawn_point.position.x *= -1
	
	flip_sprite(direction, secondary_arm_animated_sprite_2d, right_facing_position, left_facing_position)
	attack_direction = direction

func _on_attack_cool_down_timer_timeout() -> void:
	can_attack = true
	#secondary_arm_animated_sprite_2d.play("default")
