extends BabyBodyPart


const DEFAULT_PROJECTILE_ATTACK = preload("res://Graeme/Scenes/Attacks/default_projectile_attack.tscn")
const DEFAULT_NAME: String = "default"

@onready var the_baby: TheBaby = $".."

@onready var attack_cool_down_timer: Timer = $AttackCoolDownTimer
@onready var attack_spawn_point: Node2D = $AttackSpawnPoint



var can_attack: bool = true
var current_type: String = DEFAULT_NAME
var attack_direction = -1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	the_baby.on_change_direction.connect(change_attack_direction)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func attack():

	if can_attack:
		can_attack = false
		attack_cool_down_timer.start()
		
		if current_type == DEFAULT_NAME:
			#spawn projectile
			var default_projectile_attack_instance = DEFAULT_PROJECTILE_ATTACK.instantiate()
			get_tree().current_scene.add_child(default_projectile_attack_instance)
			default_projectile_attack_instance.global_position = attack_spawn_point.global_position

			print("attack direction" + str(attack_direction))
			default_projectile_attack_instance.set_direction(attack_direction)

func change_attack_direction(direction):
	if direction == 1 and attack_spawn_point.position.x < 0 or direction == -1 and attack_spawn_point.position.x > 0:
		attack_spawn_point.position.x *= -1
	
	
	attack_direction = direction

func _on_attack_cool_down_timer_timeout() -> void:
	can_attack = true
