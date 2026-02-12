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

var leg_type: int = 0



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	the_baby.on_toggle_move.connect(toggle_movement)
	the_baby.on_item_picked_up.connect(swap_part)
	
func swap_part(body_part: String):
	if (body_part == DEFAULT_NAME):
		speed = DEFAULT_SPEED
		jump_velocity = DEFAULT_JUMP_VELOCITY
	elif (body_part == STROLLER_NAME):
		speed = STROLLER_SPEED
		jump_velocity = STROLLER_JUMP_VELOCITY
	
	print(speed)
func toggle_movement(is_moving: bool):
	
	#TODO: add in once we have animation sprites
	'''
	if (is_moving):
		# play walking animation
		if (leg_type == DEFAULT_TYPE):
			legs_animated_sprite_2d.play(DEFAULT_MOVING_ANIMATION_STRING)
		elif (leg_type == STROLLER_TYPE):
			legs_animated_sprite_2d.play(STROLLER_MOVING_ANIMATION_STRING)
	# if not moving
	else:
		if (leg_type == DEFAULT_TYPE):
			legs_animated_sprite_2d.play(DEFAULT_MOVING_ANIMATION_STRING)
		elif (leg_type == STROLLER_TYPE):
			legs_animated_sprite_2d.play(STROLLER_MOVING_ANIMATION_STRING)
	'''
	

	
