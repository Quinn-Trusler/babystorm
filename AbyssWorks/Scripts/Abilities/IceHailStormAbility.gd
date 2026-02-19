extends Ability
class_name IceHailStormAbility

@export var iceAttackAnim: String = ""

@export_group("HailStorm control")
@export var forceMin: float = 150
@export var forceMax: float = 300

@export var effectDuration: float = 10
@export var spawnInterval: float = 2
@export var spawnFirstIce: bool = true

@export_group("Damage")
@export var damageAmount: float = 0
@export var damageType: DamageInfo.DamageType = DamageInfo.DamageType.Ice


var characterBody2D: CharacterBody2D = null
var anim_player: AnimationPlayer = null

var _cooldownTimer: float = 0
var isExecuting: bool = false

const ICE_HAIL_STORM = preload("res://AbyssWorks/Prefabs/Specials/IceHailStorm.tscn")

func External_Ready() -> void:
	characterBody2D = _variable_dict["char_body"]
	anim_player = _variable_dict["anim_player"]
	
	if not allowFirst:
		_cooldownTimer = cooldownTime
		
	pass

func IsExecuting():
	return isExecuting
	
func CanTrigger():
	return not isExecuting and _cooldownTimer <= 0

func Trigger():
	_spawn_hail()
	
	if (anim_player and iceAttackAnim != ""):
		isExecuting = true
		_cooldownTimer = cooldownTime
		anim_player.play(iceAttackAnim)
	else:
		isExecuting = false
	pass
	
func ExecutionCancel():
	isExecuting = false
	pass
	
func External_Process(delta):
	if not isExecuting:
		if not usePhysicsDelta:
			_cooldownTimer = maxf(_cooldownTimer - delta, 0)
		return
		
	if not usePhysicsDelta:
		_condition_cooldown(delta)
		
	pass

func External_PhysicsProcess(delta):
	if not isExecuting:
		if usePhysicsDelta:
			_cooldownTimer = maxf(_cooldownTimer - delta, 0)
		return
		
	if usePhysicsDelta:
		_condition_cooldown(delta)
			
	if not anim_player.is_playing():
		isExecuting = false
	
	pass
	
func _condition_cooldown(delta):
	if tickWhileExecuting:
		_cooldownTimer = maxf(_cooldownTimer - delta, 0)
	else:
		_cooldownTimer = cooldownTime
		
func _spawn_hail():
	if not characterBody2D:
		return
	
	var ice_hail_storm_instance = ICE_HAIL_STORM.instantiate()
	if ice_hail_storm_instance is IceHailStorm:
		var ice_hail_storm: IceHailStorm = ice_hail_storm_instance
		ice_hail_storm.instigator = characterBody2D
		ice_hail_storm.damageInfo = DamageInfo.new(damageAmount, characterBody2D, damageType)
		ice_hail_storm.forceMin = forceMin
		ice_hail_storm.forceMax = forceMax
		ice_hail_storm.effectDuration = effectDuration
		ice_hail_storm.spawnFirstIce = spawnFirstIce
		ice_hail_storm.spawnInterval = spawnInterval
		ice_hail_storm.global_position = characterBody2D.global_position
		
	characterBody2D.get_tree().current_scene.add_child(ice_hail_storm_instance)
	
	pass
