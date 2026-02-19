extends BabyBodyPart

@export var health: float = 100
@export var health_bar: TextureProgressBar
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_bar.max_value = health
	health_bar.value = health
func take_damage(damage)->void:
	health -= damage
	health_bar.value = health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
