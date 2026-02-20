extends BabyBodyPart

const DEFAULT_ATTACK = preload("res://Graeme/Scenes/Attacks/default_attack.tscn")
const STRONG_ATTACK = preload("res://Graeme/Scenes/Attacks/strong_attack.tscn")

@onready var the_baby: TheBaby = $".."

@onready var attack_cool_down_timer: Timer = $AttackCoolDownTimer
@onready var attack_spawn_point: Node2D = $AttackSpawnPoint
@onready var main_arm_animated_sprite_2d: AnimatedSprite2D = $MainArmAnimatedSprite2D

const DEFAULT_NAME = "default main"
const STRONG_NAME = "strong main"

@export var attack_cooldown: float = 0.5

var current_type: String = STRONG_NAME
var can_attack = true

var right_facing_position: Vector2 = Vector2(6, 10)
var left_facing_position: Vector2 = Vector2(-4, 6)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	the_baby.on_change_direction.connect(change_attack_direction)
	the_baby.on_swapped_body_part.connect(swap_body_part)
	attack_cool_down_timer.wait_time = attack_cooldown
	
func swap_body_part(body_part):
	if body_part == DEFAULT_NAME or body_part == STRONG_NAME:
		current_type = body_part
		GameManager.main_arm_body_part = body_part
		
	if current_type == STRONG_NAME:
		attack_cool_down_timer.wait_time = 1
		main_arm_animated_sprite_2d.play("strongMainStatic")
	elif current_type == DEFAULT_NAME:
		attack_cool_down_timer.wait_time = .2
		main_arm_animated_sprite_2d.play("defaultMainStatic")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func change_attack_direction(direction: int):
	if direction == 1 and attack_spawn_point.position.x < 0 or direction == -1 and attack_spawn_point.position.x > 0:
		attack_spawn_point.position.x *= -1
		
	if direction < 0:
		main_arm_animated_sprite_2d.flip_h = true
	else:
		main_arm_animated_sprite_2d.flip_h = false
		
	
func attack():

	if can_attack:
		can_attack = false
		attack_cool_down_timer.start()
		if current_type == DEFAULT_NAME:
			var default_attack_instance = DEFAULT_ATTACK.instantiate()
			if default_attack_instance is DefaultAttack:
				var default_attack: DefaultAttack = default_attack_instance
				default_attack.instigator = the_baby
				
			add_child(default_attack_instance)
			default_attack_instance.global_position = attack_spawn_point.global_position
			main_arm_animated_sprite_2d.play("defaultMainPunch")
		if current_type == STRONG_NAME:
			var strong_attack_instance = STRONG_ATTACK.instantiate()
			if strong_attack_instance is StrongAttack:
				var strong_attack: StrongAttack = strong_attack_instance
				strong_attack.instigator = the_baby
				
			add_child(strong_attack_instance)
			strong_attack_instance.global_position = attack_spawn_point.global_position
			main_arm_animated_sprite_2d.play("strongMainPunch")


func _on_attack_cool_down_timer_timeout() -> void:
	can_attack = true
	#main_arm_animated_sprite_2d.play("default")
