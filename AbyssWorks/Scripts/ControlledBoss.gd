extends CharacterBody2D

@export var SPEED: float = 300.0
@export var JUMP_VELOCITY: float = 400.0

var bulletRes = preload("res://AbyssWorks/Prefabs/BulletBall.tscn")

@export var customForce2D: CustomForce2D

var isGrounded: bool;
var rotateDirection: Vector2 = Vector2.RIGHT
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (customForce2D):
		customForce2D.node2D = self
	pass # Replace with function body.

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") and isGrounded:
		customForce2D.AddForce(Vector2.UP * JUMP_VELOCITY, CustomForce2D.ForceMode.Impulse)
		
	if Input.is_action_just_pressed('Shoot'):
		var bulletInstance = bulletRes.instantiate()
		get_tree().current_scene.add_child(bulletInstance)
		bulletInstance.moveDirection = rotateDirection
		bulletInstance.instigator = self
		bulletInstance.position = position
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	isGrounded = is_on_floor()
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		rotateDirection = Vector2.RIGHT * direction
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if (customForce2D):
		customForce2D._simulate_forces(isGrounded, delta)
		velocity += customForce2D.velocity
	
	move_and_slide()
	pass
