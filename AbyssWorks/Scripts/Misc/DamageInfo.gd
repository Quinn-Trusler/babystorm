extends RefCounted
class_name DamageInfo

enum DamageType {Physical, Fire, Ice}

var amount: float = 0
var instigator: Node2D = null
var damageType: DamageType = DamageType.Physical
var hitPoint: Vector2 = Vector2.ZERO
var hitNormal: Vector2 = Vector2.ZERO
func _init(
	_amount: float = 0,
	_instigator: Node2D = null,
	_damageType: DamageType = DamageType.Physical,
	_hitPoint: Vector2 = Vector2.ZERO,
	_hitNormal: Vector2 = Vector2.ZERO
):
	amount = _amount
	instigator = _instigator
	damageType = _damageType
	hitPoint = _hitPoint
	hitNormal = _hitNormal
