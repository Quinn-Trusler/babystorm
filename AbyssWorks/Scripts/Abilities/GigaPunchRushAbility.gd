extends Ability
class_name GigaPunchRushAbility

@export var gigaAnimName: String = ""
@export var dashTime: float = 3
@export var dashSpeed: float = 4
@export var attackDistance: float = 400

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
	_dashTimer = dashTime
	_canDash = true

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
			
	_cooldownTimer = cooldownTime
	
	pass

func ExecutionCancel():
	isExecuting = false
	_canDash = false
	_cooldownTimer = 0
	_dashTimer = 0
	_enable_hitboxes(false)
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
				
	
	if _dashTimer > 0:
		if characterBody2D:
			characterBody2D.velocity.x = sign(characterBody2D.transform.x.x) * dashSpeed
			characterBody2D.velocity.y = 0
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
	if hitboxes:
		for hitbox: Hitbox in hitboxes:
			if hitbox:
				hitbox._set_enabled_status(status)
				pass
func _reset_hitboxes():
	if hitboxes:
		for hitbox: Hitbox in hitboxes:
			if hitbox:
				hitbox._clear_hit_objects()
