extends Ability
class_name BasicPunchAbility

@export_range(1, 100) var consecutiveHits: int = 1
@export var attackDistance: float = 180
@export var anim_speed_add: float = 0
@export var basicAttackAnims: Array[String] = []

@export_group("Damage")
@export var damageAmount: float = 0
@export var damageType: DamageInfo.DamageType = DamageInfo.DamageType.Physical

var anim_player: AnimationPlayer = null
var hitboxes: Array[Hitbox] = []

var _cooldownTimer: float = 0
var isExecuting: bool = false

var _consecutiveCount: int = 1

func External_Ready():
	damageAmount = AbilityDamageAmount.punchAbilityDamage
	
	anim_player = _variable_dict["anim_player"]
	hitboxes = _variable_dict["hitboxes"]
	
	_enable_hitboxes(false)
	
	if not allowFirst:
		_cooldownTimer = cooldownTime
	
	pass
	
func _modifyDamageAndForceInfo(_body: Node2D, damageInfo: DamageInfo, _forceInfo: ForceInfo):
	damageInfo.amount = damageAmount
	damageInfo.damageType = damageType		
	pass	

func IsExecuting():
	return isExecuting
	
func CanTrigger():
	return not isExecuting and _cooldownTimer <= 0
	
func Trigger():
	if (anim_player and basicAttackAnims.size() > 0):
		_enable_hitboxes(true)
		_reset_hitboxes()
		anim_player.speed_scale += anim_speed_add
		
		for hitbox: Hitbox in hitboxes:
			if hitbox:
				hitbox.onModifyDamageAndForceInfo = self._modifyDamageAndForceInfo
		
		isExecuting = true
		_cooldownTimer = cooldownTime
		_consecutiveCount = 1
		anim_player.play(basicAttackAnims.pick_random())
	pass
	
func ExecutionCancel():
	if not isExecuting:
		return
		
	isExecuting = false
	if anim_player:
		anim_player.speed_scale -= anim_speed_add
	_enable_hitboxes(false)
	_reset_hitboxes()
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
			
	if not anim_player.is_playing():
		if _consecutiveCount >= consecutiveHits:
			_enable_hitboxes(false)
			isExecuting = false
			
			anim_player.speed_scale -= anim_speed_add
			return
		_consecutiveCount+=1
		_turn_of_damage_hitboxes(false)
		_reset_hitboxes()
		
		for hitbox: Hitbox in hitboxes:
			if hitbox:
				hitbox.onModifyDamageAndForceInfo = self._modifyDamageAndForceInfo
				
		anim_player.play(basicAttackAnims.pick_random())
	
	pass
	
func _condition_cooldown(delta):
	if tickWhileExecuting:
		_cooldownTimer = maxf(_cooldownTimer - delta, 0)
	else:
		_cooldownTimer = cooldownTime

func _enable_hitboxes(status: bool):
	if hitboxes:
		for hitbox: Hitbox in hitboxes:
			if hitbox:
				hitbox._set_enabled_status(status)
				pass
				
func _turn_of_damage_hitboxes(status: bool):
	if hitboxes:
		for hitbox: Hitbox in hitboxes:
			if hitbox:
				hitbox.canDealDamage = false
				pass
				
func _reset_hitboxes():
	if hitboxes:
		for hitbox: Hitbox in hitboxes:
			if hitbox:
				hitbox._clear_hit_objects()
