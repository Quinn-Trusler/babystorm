extends BabyBodyPart


const DEFAULT_NAME: String = "default"
const STROLLER_NAME: String = "stroller"

const DEFAULT_SPEED: float = 300
const STROLLER_SPEED: float = 500

const DEFAULT_JUMP_VELOCITY: float = -300
const STROLLER_JUMP_VELOCITY:float = -500


const DEFAULT_IDLE_ANIMATION_STRING: String = "default idle"
const DEFAULT_MOVING_ANIMATION_STRING: String = "default moving"
const STROLLER_IDLE_ANIMATION_STRING: String = "stroller idle"
const STROLLER_MOVING_ANIMATION_STRING: String = "stroller moving"


@onready var the_baby: CharacterBody2D = $".."
@onready var legs_animated_sprite_2d: AnimatedSprite2D = $LegsAnimatedSprite2D

@export var speed: float = 300
@export var jump_velocity = -400.0

var type: String = DEFAULT_NAME

var right_facing_position: Vector2 = Vector2(-7, -4)
var left_facing_position: Vector2 = Vector2(8, -4)



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	the_baby.on_toggle_move.connect(toggle_movement)
	#the_baby.on_item_picked_up.connect(swap_part)
	the_baby.on_change_direction.connect(change_direction)
	the_baby.on_toggle_jump.connect(toggle_jump)
	
	
func change_direction(direction: int):
	#flip_sprite(direction, legs_animated_sprite_2d, right_facing_position, left_facing_position)
	if direction < 0:
		legs_animated_sprite_2d.flip_h = true
	else:
		legs_animated_sprite_2d.flip_h = false
	
func swap_part(body_part: String):
	if (body_part == DEFAULT_NAME):
		speed = DEFAULT_SPEED
		jump_velocity = DEFAULT_JUMP_VELOCITY
	elif (body_part == STROLLER_NAME):
		speed = STROLLER_SPEED
		jump_velocity = STROLLER_JUMP_VELOCITY
	
	print(speed)
	
func toggle_jump(has_jumped):
	if (has_jumped):
		legs_animated_sprite_2d.play("jump")
	else:
		legs_animated_sprite_2d.play("idle")
	
func toggle_movement(is_moving: bool):
	
	#TODO: add in once we have animation sprites
	
	if (is_moving):
		# play walking animationif (leg_type == DEFAULT_TYPE):
		legs_animated_sprite_2d.play("walk")
	else:
		legs_animated_sprite_2d.play("idle")
	# if not moving
	'''
	else:
		if (leg_type == DEFAULT_TYPE):
			legs_animated_sprite_2d.play(DEFAULT_MOVING_ANIMATION_STRING)
		elif (leg_type == STROLLER_TYPE):
			legs_animated_sprite_2d.play(STROLLER_MOVING_ANIMATION_STRING)
	'''
	

	
