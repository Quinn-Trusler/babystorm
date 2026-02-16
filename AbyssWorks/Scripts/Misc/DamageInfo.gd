extends RefCounted
class_name DamageInfo

enum DamageType {Physical, Fire, Ice}

var amount: float = 0
var instigator: Node2D = null
var damageType: DamageType = DamageType.Physical
func _init(
	_amount: float = 0,
	_instigator: Node2D = null,
	_damageType: DamageType = DamageType.Physical
):
	amount = _amount
	instigator = _instigator
	damageType = _damageType
