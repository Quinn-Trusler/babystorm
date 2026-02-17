extends ResourceBehaviour
class_name  CustomForce2D

enum ForceMode { Force, Impulse, Acceleration, VelocityChange }

# =========================
# Physics Properties
# =========================
@export var mass: float = 1.0

# =========================
# Forces
# =========================
@export var gravity_scale: float = 1.0
@export var gravity: float = 980.0 
@export var ground_friction: float = 8.0
@export var air_drag: float = 0.1
@export var static_gravity: float = 50.0
@export var max_terminal_velocity: float = 4000.0

var velocity: Vector2 = Vector2.ZERO
var accumulated_forces: Vector2 = Vector2.ZERO

var node2D: Node2D = null

func _simulate_forces(is_grounded: bool, delta: float) -> void:
	# Gravity
	if is_grounded and velocity.y > 0.0:
		velocity.y = static_gravity * gravity_scale
		_apply_friction(delta)
	else:
		if velocity.y < max_terminal_velocity:
			velocity.y += gravity * gravity_scale * delta

		_apply_drag(delta)
		
	# Apply accumulated forces
	velocity += accumulated_forces * delta
	accumulated_forces = Vector2.ZERO
	
func AddForce(force: Vector2, forceMode: ForceMode) -> void:
	match forceMode:
		ForceMode.Force:
			accumulated_forces += force / mass
		ForceMode.Acceleration:
			accumulated_forces += force
		ForceMode.Impulse:
			velocity += force / mass
		ForceMode.VelocityChange:
			velocity += force
		_:
			pass

func AddExplosionForce(
		explosion_force: float,
		explosion_position: Vector2,
		explosion_radius: float,
		upwards_modifier: float = 0.0,
		forceMode: ForceMode = ForceMode.Impulse
	) -> void:

	if explosion_radius <= 0.0 or is_equal_approx(explosion_force, 0.0):
		return

	if node2D == null:
		return

	var dir: Vector2 = node2D.global_position - (explosion_position - Vector2.UP * upwards_modifier)

	var distance := dir.length()

	if distance > explosion_radius:
		return

	if dir.length_squared() < 0.00001:
		dir = Vector2.UP
	else:
		dir = dir.normalized()

	var falloff := clampf(1.0 - distance / explosion_radius, 0.0, 1.0)

	var force := explosion_force * falloff * dir

	AddForce(force, forceMode)


func ResetForces() -> void:
	velocity = Vector2.ZERO
	accumulated_forces = Vector2.ZERO
	
func _apply_friction(delta: float) -> void:
	'''
	velocity.x -= velocity.x * ground_friction * delta

	if abs(velocity.x) < 0.01:
		velocity.x = 0.0
	'''
	velocity.x = move_toward(velocity.x, 0, ground_friction * delta)


func _apply_drag(delta: float) -> void:
	velocity.x -= velocity.x * air_drag * delta

	if abs(velocity.x) < 0.01:
		velocity.x = 0.0
