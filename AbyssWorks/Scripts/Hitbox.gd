extends Area2D
class_name Hitbox

@export var instigator: Node2D = null

@export var target: Node2D = null
@export var targetGroups: Array[String] = []

@export var canDealDamage: bool = false

@export_group("Modulate control")
@export var metaDataOwner: Node2D = null
@export var metaDataName: String = ""
@export var isSelfModulate: bool = true

var damageInfo: DamageInfo = null
var forceInfo: ForceInfo = null

var _hitObjects: Array[Node2D] = []

func _set_enabled_status(status: bool) -> void:
	if not status:
		canDealDamage = false
	set_deferred("monitoring", status)

func _clear_hit_objects():
	_hitObjects.clear()

func _physics_process(delta: float) -> void:
	if not canDealDamage:
		return
	var overlappingBodies: Array[Node2D] = get_overlapping_bodies()
	
	for body: Node2D in overlappingBodies:
		if body == instigator or _hitObjects.has(body):
			continue	
	
		if body is CharacterBase:
			_hitObjects.append(body)
			print(body, " ", _hitObjects.has(body))
			var characterBase: CharacterBase = body
			characterBase.ApplyDamageAndForce(damageInfo, forceInfo)
			
	pass

func _is_in_target_groups(node2D: Node2D) -> bool:
	for group_name in targetGroups:
		if node2D.is_in_group(group_name):
			return true
	return false
