extends Ability
class_name GigaPunchRushAbility

@export var gigaAnimName: String = ""
@export var dashTime: float = 3
@export var dashSpeed: float = 4

@export_group("Execution delay control")
@export var cooldownTime: float = 0
@export var allowFirst: bool = false
@export var tickWhileExecuting: bool = false
@export var usePhysicsDelta: bool = true

var characterBody2D: CharacterBody2D = null
var customForce2D: CustomForce2D = null
var animationSubscriber: AnimationSubscriber = null

var dashDirection: float = 0

var prevGravityScale: float = 0
var isExecuting: bool = false

var _dashTimer: float = 0
var _canDash: bool = false

var _cooldownTimer: float = 0

func External_Ready():
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
	
	_cooldownTimer = cooldownTime
	
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
				
	
	if _dashTimer > 0:
		if characterBody2D:
			characterBody2D.velocity.x = dashDirection * dashSpeed
			characterBody2D.velocity.y = 0
		if customForce2D:
			customForce2D.ResetForces()
		_dashTimer -= delta
	elif _canDash:
		isExecuting = false
		_canDash = false
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
