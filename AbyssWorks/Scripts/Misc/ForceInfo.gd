extends RefCounted
class_name ForceInfo

enum ForceType {Normal, Explosion, Implosion}

var force: Vector2 = Vector2.ZERO
var forceMode: CustomForce2D.ForceMode = CustomForce2D.ForceMode.Impulse
var explosionForce: float = 0
var explosionPosition: Vector2 = Vector2.ZERO
var explosionRadius: float = 0
var upwardsModifier: float = 0
func _init(
	_force: Vector2 = Vector2.ZERO,
	_forceMode: CustomForce2D.ForceMode = CustomForce2D.ForceMode.Impulse,
	_explosionForce: float = 0,
	_explosionPosition: Vector2 = Vector2.ZERO,
	_explosionRadius: float = 0,
	_upwardsModifier: float = 0
):
	force = _force
	forceMode = _forceMode
	explosionForce = _explosionForce
	explosionPosition = _explosionPosition
	explosionRadius = _explosionRadius
	upwardsModifier = _upwardsModifier
