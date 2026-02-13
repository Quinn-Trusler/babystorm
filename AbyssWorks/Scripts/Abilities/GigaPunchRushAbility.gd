extends ResourceBehaviour
class_name GigaPunchRushAbility

@export var gigaAnimName: String = ""
@export var dashTime: float = 3
@export var dashSpeed: float = 4

var characterBody2D: CharacterBody2D = null
var customForce2D: CustomForce2D = null
var animationSubscriber: AnimationSubscriber = null

var dashDirection: float = 0

var prevGravityScale: float = 0
var isExecuting: bool = true

var _dashTimer: float = 0
var _canDash: bool = false

func External_Ready():
	if animationSubscriber:
		animationSubscriber.SubscribeCallable("PunchRush", self._start_dash)
	pass

func _start_dash():
	_dashTimer = dashTime
	_canDash = true

func Trigger():
	if animationSubscriber:
		animationSubscriber.play(gigaAnimName)
	isExecuting = true
	pass
	
func External_Process(delta):
	if not isExecuting:
		return
	
	pass

func External_PhysicsProcess(delta):
	if not isExecuting:
		return
	
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
