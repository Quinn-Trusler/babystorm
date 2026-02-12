extends Node2D
class_name BabyBodyPart

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func swap_part(body_part: String):
	pass

func set_new_animation(animation_name: String, animated_sprite: AnimatedSprite2D):
	animated_sprite.play(animation_name)
