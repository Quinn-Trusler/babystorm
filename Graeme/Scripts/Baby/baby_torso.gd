extends BabyBodyPart

@export var health: float = 100

func take_damage(damage)->void:
	health -= damage

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
