extends BossAttackState

const FIRE_PROJECTILE = preload("res://Graeme/Scenes/Bosses/FireBoss/fire_projectile.tscn")

@onready var fire_boss: Node2D = $"../.."
@onready var fire_boss_state_machine: FireBossStateMachine = $".."
@onready var heavy_state_timer: Timer = $heavyStateTimer
@onready var heavy_attack_timer: Timer = $heavyAttackTimer
@onready var arms_animated_sprite_2d_2: AnimatedSprite2D = $"../../Animations/ArmsAnimatedSprite2D2"
@onready var animation_timer: Timer = $"../../animationTimer"

var player: TheBaby = null

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")	

# Called when the node enters the scene tree for the first time.
func enter() -> void:
	heavy_state_timer.start()
	heavy_attack_timer.start()
	animation_timer.start()
	print("entering heavy attack")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(delta: float) -> void:
	#print("heavy attack")
	#print(state_timer.time_left)
	pass

func _on_heavy_state_timer_timeout() -> void:
	pass
	



func _on_heavy_attack_timer_timeout() -> void:
	var fire_projectile_instance_1 = FIRE_PROJECTILE.instantiate()
	get_tree().current_scene.add_child(fire_projectile_instance_1)
	fire_projectile_instance_1.global_position = fire_boss.global_position
	
	var fire_projectile_instance_2 = FIRE_PROJECTILE.instantiate()
	get_tree().current_scene.add_child(fire_projectile_instance_2)
	fire_projectile_instance_2.global_position = fire_boss.global_position
	
	var fire_projectile_instance_3 = FIRE_PROJECTILE.instantiate()
	get_tree().current_scene.add_child(fire_projectile_instance_3)
	fire_projectile_instance_3.global_position = fire_boss.global_position
	
	
	var player_direction: Vector2 = (player.global_position - fire_boss.global_position).normalized()
	fire_projectile_instance_1.initialize(player_direction)
	fire_projectile_instance_2.initialize(player_direction.rotated(deg_to_rad(20)))
	fire_projectile_instance_3.initialize(player_direction.rotated(deg_to_rad(-20)))
	
	#arms_animated_sprite_2d_2.play("static")
	
	fire_boss_state_machine.set_next_state()


func _on_animation_timer_timeout() -> void:
	arms_animated_sprite_2d_2.play("default")
