extends ResourceBehaviour
class_name AbsoluteDashAbility

@export var dashTime: float = 3
@export var dashSpeed: float = 4

var characterBody2D: CharacterBody2D = null
var customForce2D: CustomForce2D = null
var dashDirection: float = 0

var prevGravityScale: float = 0
var isExecuting: bool = true

var _dashTimer: float = 0

func Trigger():
	if customForce2D:
		prevGravityScale = customForce2D.gravity_scale
		customForce2D.gravity_scale = 0
	_dashTimer = dashTime
	pass
	
func External_Process(delta):
	if not isExecuting:
		return
	
	pass

func External_PhysicsProcess(delta):
	if not isExecuting:
		return
	
	if characterBody2D:
		characterBody2D.velocity.x = dashDirection * dashSpeed
	
	_dashTimer -= delta
	
	pass

func IsExecuting():
	return isExecuting
