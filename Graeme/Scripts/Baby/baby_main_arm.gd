extends BabyBodyPart

const DEFAULT_ATTACK = preload("res://Graeme/Scenes/Attacks/default_attack.tscn")



@onready var the_baby: TheBaby = $".."

@onready var attack_cool_down_timer: Timer = $AttackCoolDownTimer
@onready var attack_spawn_point: Node2D = $AttackSpawnPoint
@onready var main_arm_animated_sprite_2d: AnimatedSprite2D = $MainArmAnimatedSprite2D

const DEFAULT_NAME = "default"
const PROJECTILE_NAME = "projectile" 

@export var attack_cooldown: float = 0.5

var current_type: String = DEFAULT_NAME
var can_attack = true

var right_facing_position: Vector2 = Vector2(6, 10)
var left_facing_position: Vector2 = Vector2(-4, 6)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	the_baby.on_change_direction.connect(change_attack_direction)
	attack_cool_down_timer.wait_time = attack_cooldown
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func change_attack_direction(direction: int):
	if direction == 1 and attack_spawn_point.position.x < 0 or direction == -1 and attack_spawn_point.position.x > 0:
		attack_spawn_point.position.x *= -1
		
	flip_sprite(direction, main_arm_animated_sprite_2d, right_facing_position, left_facing_position)
		
	
func attack():

	if can_attack:
		can_attack = false
		attack_cool_down_timer.start()
		
		if current_type == DEFAULT_NAME:
			var default_attack_instance = DEFAULT_ATTACK.instantiate()
			add_child(default_attack_instance)
			default_attack_instance.global_position = attack_spawn_point.global_position
			main_arm_animated_sprite_2d.play("mainArmPunch")


func _on_attack_cool_down_timer_timeout() -> void:
	can_attack = true
	#main_arm_animated_sprite_2d.play("default")
