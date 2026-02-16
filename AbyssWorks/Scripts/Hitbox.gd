extends Area2D
class_name Hitbox

var target: Node2D = null
var targetGroups: Array[String] = []

var canDealDamage: bool = false

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

func _on_body_entered(body: Node2D) -> void:
	if not canDealDamage:
		return
		
	if _hitObjects.has(body):
		return
		
	if _is_in_target_groups(body) and body is CharacterBase:
		_hitObjects.append(body)
		var characterBase: CharacterBase = body
		characterBase.ApplyDamageAndForce(damageInfo, forceInfo)			
	pass # Replace with function body.


func _on_body_exited(body: Node2D) -> void:
	pass # Replace with function body.

func _is_in_target_groups(node2D: Node2D) -> bool:
	for group_name in targetGroups:
		if node2D.is_in_group(group_name):
			return true
	return false
