extends Ability
class_name IceProjectileAbility

@export_range(1, 100) var consecutiveHits: int = 1
@export var attackDistance: float = 400
@export var iceAttackAnims: Array[String] = []

@export_group("Damage")
@export var damageAmount: float = 0
@export var damageType: DamageInfo.DamageType = DamageInfo.DamageType.Ice

var anim_spawn_dict: Dictionary[String, Node2D] = {}

var characterBody2D: CharacterBody2D = null
var anim_subsc: AnimationPlayer = null

var _cooldownTimer: float = 0
var isExecuting: bool = false

var _consecutiveCount: int = 1
var _currentAnim: String = ""

const ICE_PROJECTILE_ATTACK = preload("res://Graeme/Scenes/Attacks/default_projectile_attack.tscn")

func External_Ready() -> void:
	characterBody2D = _variable_dict["char_body"]
	anim_subsc = _variable_dict["anim_subsc"]
	anim_spawn_dict = _variable_dict["anim_spawn_dict"]
	
	if anim_subsc:
		anim_subsc.SubscribeCallable("Launch", self._spawn_on_current_anim)
	
	if not allowFirst:
		_cooldownTimer = cooldownTime
	
	pass
	
func IsExecuting():
	return isExecuting
	
func CanTrigger():
	return not isExecuting and _cooldownTimer <= 0
	
func Trigger():
	if (anim_subsc and iceAttackAnims.size() > 0):
		isExecuting = true
		_cooldownTimer = cooldownTime
		_consecutiveCount = 1
		_currentAnim = iceAttackAnims.pick_random()
		anim_subsc.play(_currentAnim)
	pass
	
func ExecutionCancel():
	isExecuting = false
	_currentAnim = ""
	pass
	
func CheckRequirements(distance: float) -> bool:
	return distance <= attackDistance
	
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
			
	if not anim_subsc.is_playing():
		if _consecutiveCount >= consecutiveHits:
			isExecuting = false
			_currentAnim = ""
			return
		_consecutiveCount+=1
		anim_subsc.play(iceAttackAnims.pick_random())
	
	pass
	
func _condition_cooldown(delta):
	if tickWhileExecuting:
		_cooldownTimer = maxf(_cooldownTimer - delta, 0)
	else:
		_cooldownTimer = cooldownTime
		
func _spawn_on_current_anim():
	if _currentAnim != "":
		_spawn_projectile(anim_spawn_dict[_currentAnim])

func _spawn_projectile(spawnPoint: Node2D):
	if not characterBody2D and not spawnPoint:
		return
	
	var default_projectile_attack_instance = ICE_PROJECTILE_ATTACK.instantiate()
	if default_projectile_attack_instance is DefaultProjectile:
		var default_projectile: DefaultProjectile = default_projectile_attack_instance
		default_projectile.instigator = characterBody2D
		
	characterBody2D.get_tree().current_scene.add_child(default_projectile_attack_instance)
	default_projectile_attack_instance.global_position = spawnPoint.global_position
	
	default_projectile_attack_instance.set_direction(sign(characterBody2D.transform.x.x))
	pass
