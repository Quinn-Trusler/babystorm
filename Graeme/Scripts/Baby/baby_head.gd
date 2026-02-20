extends BabyBodyPart

@onready var the_baby: TheBaby = $".."
@onready var head_animated_sprite_2d: AnimatedSprite2D = $HeadAnimatedSprite2D

var right_facing_position: Vector2 = Vector2(-8, -5)
var left_facing_position: Vector2 = Vector2(8, -5)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	the_baby.on_change_direction.connect(change_direction)
	the_baby.on_toggle_move.connect(toggle_movement)
	the_baby.on_toggle_jump.connect(toggle_jump)
	
	
func toggle_jump(has_jumped):
	if (has_jumped):
		head_animated_sprite_2d.play("jump")
	else:
		head_animated_sprite_2d.play("idle")
		
func toggle_movement(is_moving: bool):
	
	#TODO: add in once we have animation sprites
	
	if (is_moving):
		# play walking animationif (leg_type == DEFAULT_TYPE):
		head_animated_sprite_2d.play("walk")
	else:
		head_animated_sprite_2d.play("idle")
		
		
func change_direction(direction: int):
	#flip_sprite(direction, legs_animated_sprite_2d, right_facing_position, left_facing_position)
	if direction < 0:
		head_animated_sprite_2d.flip_h = true
	else:
		head_animated_sprite_2d.flip_h = false
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
