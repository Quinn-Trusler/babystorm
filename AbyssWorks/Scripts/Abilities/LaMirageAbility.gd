extends Ability
class_name LaMirageAbility

@export var attackDistance: float = 400
@export var mirageAttackAnim: String = ""
@export var gigaPunchRushAbility: GigaPunchRushAbility = null

@export_group("Spawn Rate Control")
@export var spawningDuration: float = 10
@export var spawningInterval: float = 2
@export var spawnInitial: bool = true

@export_group("Spawned Mirage settings")
@export var spawnEffectDuration = 1
@export var spawnMoveSpeed: float = 500

@export_group("Damage")
@export var damageAmount: float = 0
@export var damageType: DamageInfo.DamageType = DamageInfo.DamageType.Physical

var characterBody2D: CharacterBody2D = null
var anim_subsc: AnimationSubscriber = null

var _cooldownTimer: float = 0
var isExecuting: bool = false

var _is_waiting_to_start: bool = false
var _spawningTimer: float = 0
var _spawningCountdown: float = 0

var _gigaDashAbility: GigaPunchRushAbility = null

const MIRAGE_DASH_ATTACK = preload("res://AbyssWorks/Prefabs/MiragePBoss.tscn")

func External_Ready() -> void:
	characterBody2D = _variable_dict["char_body"]
	anim_subsc = _variable_dict["anim_subsc"]
	
	if gigaPunchRushAbility:
		_gigaDashAbility = gigaPunchRushAbility.duplicate(true)
		_gigaDashAbility._variable_dict = _variable_dict
		_gigaDashAbility.External_Ready()
	
	if anim_subsc:
		anim_subsc.SubscribeCallable("Launch", self._start_spawning)
	
	if not allowFirst:
		_cooldownTimer = cooldownTime
	
	pass
	
func IsExecuting() -> bool:
	return isExecuting or _is_gigaRushExecuting()

func CanTrigger():
	return not isExecuting and _cooldownTimer <= 0

func Trigger():
	if (anim_subsc and mirageAttackAnim != ""):
		isExecuting = true
		_cooldownTimer = cooldownTime
		_is_waiting_to_start = true
		anim_subsc.play(mirageAttackAnim)
	pass
	
func ExecutionCancel():
	isExecuting = false
	if _gigaDashAbility != null and _gigaDashAbility.IsExecuting():
		_gigaDashAbility.ExecutionCancel()
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
	
	if _is_waiting_to_start:
		return
			
	if not _is_waiting_to_start and _spawningTimer <= 0 and not _is_gigaRushExecuting():
		isExecuting = false
		return
	
	_spawningTimer = maxf(_spawningTimer - delta, 0)
	
	if _spawningTimer > 0:
		if _spawningCountdown >= spawningInterval:
			_spawn_mirage()
			_spawningCountdown = 0
		_spawningCountdown += delta
	elif not _is_gigaRushExecuting() and _gigaDashAbility != null:
		_gigaDashAbility.Trigger()
	
	if _is_gigaRushExecuting():
		_gigaDashAbility.External_PhysicsProcess(delta)
	
	pass

func _start_spawning():
	if not isExecuting:
		return
	
	_is_waiting_to_start = false
	_spawningTimer = spawningDuration
	_spawningCountdown = 0
	_spawn_mirage()
	pass

func _is_gigaRushExecuting() -> bool:
	return _gigaDashAbility != null and _gigaDashAbility.IsExecuting()

func _condition_cooldown(delta):
	if tickWhileExecuting:
		_cooldownTimer = maxf(_cooldownTimer - delta, 0)
	else:
		_cooldownTimer = cooldownTime

func _spawn_mirage():
	if not characterBody2D:
		return
	
	var mirage_attack_instance = MIRAGE_DASH_ATTACK.instantiate()
	if mirage_attack_instance is MirageDash:
		var mirage_attack: MirageDash = mirage_attack_instance
		mirage_attack.instigator = characterBody2D
		mirage_attack.damageInfo = DamageInfo.new(damageAmount, characterBody2D, damageType)
		mirage_attack.global_position = characterBody2D.global_position
		mirage_attack.move_direction = characterBody2D.transform.x
		mirage_attack.effect_duration = spawnEffectDuration
		mirage_attack.move_speed = spawnMoveSpeed
		mirage_attack.transform.x = characterBody2D.transform.x
		
	characterBody2D.get_tree().current_scene.add_child(mirage_attack_instance)
	
	pass
