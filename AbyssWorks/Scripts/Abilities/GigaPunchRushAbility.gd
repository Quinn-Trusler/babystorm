extends Ability
class_name GigaPunchRushAbility

@export var gigaAnimName: String = ""
@export var dashTime: float = 3
@export var dashSpeed: float = 4
@export var attackDistance: float = 400

@export_group("Damage")
@export var damageAmount: float = 0
@export var damageType: DamageInfo.DamageType = DamageInfo.DamageType.Physical

@export_group("Force")
@export var forceMode: CustomForce2D.ForceMode = CustomForce2D.ForceMode.Impulse
@export var forceType: ForceInfo.ForceType = ForceInfo.ForceType.Normal
@export var pushbackMultiplier: float = 500

var characterBody2D: CharacterBody2D = null
var customForce2D: CustomForce2D = null
var animationSubscriber: AnimationSubscriber = null
var hitboxes: Array[Hitbox] = []

var dashDirection: float = 0

var prevGravityScale: float = 0
var isExecuting: bool = false

var _dashTimer: float = 0
var _canDash: bool = false

var _cooldownTimer: float = 0

func External_Ready():
	characterBody2D = _variable_dict["char_body"]
	customForce2D = _variable_dict["custom_force"]
	animationSubscriber = _variable_dict["anim_subsc"]
	hitboxes = _variable_dict["hitboxes"]
	
	_enable_hitboxes(false)
	
	if animationSubscriber:
		animationSubscriber.SubscribeCallable("PunchRush", self._start_dash)
	
	if not allowFirst:
		_cooldownTimer = cooldownTime
		
	pass

func _start_dash():
	if not isExecuting:
		return
	_dashTimer = dashTime
	_canDash = true

func _modifyDamageAndForceInfo(body: Node2D, damageInfo: DamageInfo, forceInfo: ForceInfo):
	damageInfo.amount = damageAmount
	damageInfo.damageType = damageType
	
	forceInfo.forceMode = forceMode
	forceInfo.forceType = forceType
	
	if characterBody2D:
		forceInfo.force = (body.global_position - characterBody2D.global_position).normalized() * pushbackMultiplier
			
	pass

func CanTrigger():
	#print("was checked")
	#print(isExecuting, " ", _cooldownTimer)
	return not isExecuting and _cooldownTimer <= 0

func Trigger():
	if animationSubscriber:
		animationSubscriber.play(gigaAnimName)
		isExecuting = true
		_enable_hitboxes(true)
		_reset_hitboxes()
		
		for hitbox: Hitbox in hitboxes:
			if hitbox:
				hitbox.onModifyDamageAndForceInfo = self._modifyDamageAndForceInfo
				
		_cooldownTimer = cooldownTime
		
	pass

func ExecutionCancel():
	isExecuting = false
	_canDash = false
	_dashTimer = 0
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
				
	#print(_dashTimer)
	if _dashTimer > 0:
		if characterBody2D:
			characterBody2D.velocity = Vector2(sign(characterBody2D.transform.x.x) * dashSpeed, 0)
			characterBody2D.move_and_slide()
			
		if customForce2D:
			customForce2D.ResetForces()
		_dashTimer -= delta
	elif _canDash:
		isExecuting = false
		_canDash = false
		_enable_hitboxes(false)
		if onExecutionComplete:
			onExecutionComplete.emit()
	
	pass

func IsExecuting():
	return isExecuting

func _condition_cooldown(delta):
	if tickWhileExecuting:
		_cooldownTimer = maxf(_cooldownTimer - delta, 0)
	else:
		_cooldownTimer = cooldownTime

func _enable_hitboxes(status: bool):
	for hitbox: Hitbox in hitboxes:
		if hitbox:
			hitbox._set_enabled_status(status)
			pass
			
func _reset_hitboxes():
	for hitbox: Hitbox in hitboxes:
		if hitbox:
			hitbox._clear_hit_objects()
