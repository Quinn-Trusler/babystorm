extends Node2D

@onready var body_animated_sprite_2d: AnimatedSprite2D = $BodyAnimatedSprite2D
@onready var arms_animated_sprite_2d: AnimatedSprite2D = $ArmsAnimatedSprite2D
@onready var arms_animated_sprite_2d2: AnimatedSprite2D = $ArmsAnimatedSprite2D2

var player: TheBaby = null

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")	
	arms_animated_sprite_2d.set_frame(0)
	arms_animated_sprite_2d.set_frame(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	arms_animated_sprite_2d.look_at(player.global_position)
	arms_animated_sprite_2d.rotation -= deg_to_rad(70)
	arms_animated_sprite_2d2.look_at(player.global_position)
	arms_animated_sprite_2d2.rotation -= deg_to_rad(70)
func play_attack_animation():
	pass
