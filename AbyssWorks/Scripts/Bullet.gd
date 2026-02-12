extends Area2D
class_name Bullet

@export var force: float = 100;
@export var destroyTimer: float = 3;
@export var customForce2D: CustomForce2D = null;

var instigator: Node2D = null
var moveDirection: Vector2 = Vector2.RIGHT
var _customForce2D: CustomForce2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_customForce2D = customForce2D.duplicate(true)
	_customForce2D.AddForce(moveDirection * force, CustomForce2D.ForceMode.Impulse)
	await get_tree().create_timer(destroyTimer).timeout
	queue_free()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += _customForce2D.velocity
	
	_customForce2D._simulate_forces(false, delta)
	pass
	


func _on_body_entered(body: Node2D) -> void:
	if body == instigator:
		return
	queue_free()
	pass # Replace with function body.
