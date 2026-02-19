extends BossAttackState

const FIRE_PROJECTILE = preload("res://Graeme/Scenes/Bosses/FireBoss/fire_projectile.tscn")

@onready var fire_boss: Node2D = $"../.."
@onready var fire_boss_state_machine: FireBossStateMachine = $".."
@onready var light_state_timer: Timer = $lightStateTimer
@onready var attack_timer: Timer = $attackTimer

var player: TheBaby = null

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")	

# Called when the node enters the scene tree for the first time.
func enter() -> void:
	light_state_timer.start()
	attack_timer.start()
	print("entering light attack")

func exit():
	attack_timer.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(delta: float) -> void:
	#print("light attack")
	pass

func _on_light_state_timer_timeout() -> void:
	#fire_boss_state_machine.change_state(1)
	pass

func _on_attack_timer_timeout() -> void:
	print("an attack")
	var fire_projectile_instance = FIRE_PROJECTILE.instantiate()
	get_tree().current_scene.add_child(fire_projectile_instance)
	fire_projectile_instance.global_position = fire_boss.global_position
	fire_projectile_instance.initialize((player.global_position - fire_boss.global_position).normalized())
	fire_boss_state_machine.set_next_state()
