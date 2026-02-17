extends Node

@export var valueX : int
@export var ballNode: Node2D
@export var fireballAbility : FireBallAbility

var _fireball: FireBallAbility = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (fireballAbility):
		_fireball = fireballAbility.duplicate(true)
		_fireball.ballNode = ballNode
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_F):
		if (fireballAbility):
			fireballAbility.Trigger()
	pass
