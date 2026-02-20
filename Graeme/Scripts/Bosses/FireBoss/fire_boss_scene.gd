extends Node2D

signal boss_defeated()

@onready var the_baby: TheBaby = $TheBaby
@onready var fire_boss: Node2D = $FireBoss
@onready var health_layer: HealthLayer = $HealthLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_layer.set_player_max_health(the_baby.get_health())
	health_layer.set_boss_max_health(fire_boss.health)
	
	fire_boss.on_health_updated.connect(update_boss_health_ui)
	the_baby.on_health_changed.connect(update_player_health_ui)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_boss_health_ui(health):
	if health <= 0:
		get_tree().change_scene_to_file("res://AbyssWorks/Prefabs/IceBoss2D.tscn")
				
	health_layer.update_boss_health_bar(health)
	
func update_player_health_ui(health):
	health_layer.update_player_health_bar(health)
