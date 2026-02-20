extends BossAttackState

const FIRE_PROJECTILE = preload("res://Graeme/Scenes/Bosses/FireBoss/fire_projectile.tscn")

@onready var fire_boss_state_machine: FireBossStateMachine = $".."
@onready var special_state_timer: Timer = $specialStateTimer
@onready var fire_boss: Node2D = $"../.."
@onready var special_attack_timer: Timer = $specialAttackTimer

var player: TheBaby = null

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")	

# Called when the node enters the scene tree for the first time.
func enter() -> void:
	special_state_timer.start()
	special_attack_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(delta: float) -> void:
	#print("special attack")
	pass


func _on_special_state_timer_timeout() -> void:
	fire_boss_state_machine.set_next_state()

	


func _on_special_attack_timer_timeout() -> void:
	print("special attack")
	for i in range(6):
		var dir = Vector2.RIGHT.rotated(TAU * i / 6)
		print(dir)
		var fire_projectile_instance = FIRE_PROJECTILE.instantiate()
		get_tree().current_scene.add_child(fire_projectile_instance)
		fire_projectile_instance.global_position = fire_boss.global_position
		fire_projectile_instance.initialize(dir)
	
	fire_boss_state_machine.set_next_state()
		
