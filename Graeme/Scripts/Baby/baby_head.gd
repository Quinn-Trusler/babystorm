extends BabyBodyPart

@onready var the_baby: TheBaby = $".."
@onready var head_animated_sprite_2d: AnimatedSprite2D = $HeadAnimatedSprite2D

var right_facing_position: Vector2 = Vector2(-8, -5)
var left_facing_position: Vector2 = Vector2(8, -5)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	the_baby.on_change_direction.connect(change_direction)
	pass
	
func change_direction(direction: int):
	flip_sprite(direction, head_animated_sprite_2d, right_facing_position, left_facing_position)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
