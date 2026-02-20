extends Node2D



var direction: Vector2 = Vector2.ONE
var speed: float = 300

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func initialize(_direction: Vector2):
	direction = _direction

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position += delta * direction * speed
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is TheBaby:
		body.take_damage(20)
