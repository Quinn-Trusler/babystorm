extends Node2D

@onready var body_animated_sprite_2d: AnimatedSprite2D = $BodyAnimatedSprite2D
@onready var arms_animated_sprite_2d: AnimatedSprite2D = $ArmsAnimatedSprite2D

var player: TheBaby = null

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	arms_animated_sprite_2d.look_at(player.global_position)

func play_attack_animation():
	pass
