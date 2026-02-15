extends Ability
class_name BasicPunchAbility

@export_range(1, 100) var consecutiveHits: int = 1
@export var basicAttackAnims: Array[String] = []

@export_group("Execution delay control")
@export var cooldownTime: float = 0
@export var allowFirst: bool = false
@export var tickWhileExecuting: bool = false
@export var usePhysicsDelta: bool = true

var anim_player: AnimationPlayer = null

var _cooldownTimer: float = 0
var isExecuting: bool = false

var _consecutiveCount: int = 1

func External_Ready():
	anim_player = _variable_dict["anim_player"]
	
	if not allowFirst:
		_cooldownTimer = cooldownTime
	
	pass
	
func IsExecuting():
	return isExecuting
	
func CanTrigger():
	return not isExecuting and _cooldownTimer <= 0
	
func Trigger():
	if (anim_player and basicAttackAnims.size() > 0):
		isExecuting = true
		_cooldownTimer = cooldownTime
		_consecutiveCount = 1
		anim_player.play(basicAttackAnims.pick_random())
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
		if _consecutiveCount >= consecutiveHits:
			isExecuting = false
			return
		_consecutiveCount+=1
		anim_player.play(basicAttackAnims.pick_random())
	
	pass
	
func _condition_cooldown(delta):
	if tickWhileExecuting:
		_cooldownTimer = maxf(_cooldownTimer - delta, 0)
	else:
		_cooldownTimer = cooldownTime
