extends CharacterBody2D
class_name CharacterBase

enum StateExecutionType { Enter, Update, FixedUpdate, Exit }
enum BehaviorState { Idle, Move, Fall, Attack, Special, Damaged }

var _currentState: BehaviorState = BehaviorState.Idle

func ApplyDamageAndForce(damageInfo: DamageInfo, forceInfo: ForceInfo):
	pass

func _move_character(velocity: Vector2):
	self.velocity = velocity
	move_and_slide()

func ExecuteState(stateExecutionType: StateExecutionType):
	match _currentState:
		BehaviorState.Idle:
			IdleState(stateExecutionType)
		BehaviorState.Move:
			MoveState(stateExecutionType)
		BehaviorState.Fall:
			FallState(stateExecutionType)
		BehaviorState.Attack:
			AttackState(stateExecutionType)
		BehaviorState.Special:
			SpecialState(stateExecutionType)
		BehaviorState.Damaged:
			DamagedState(stateExecutionType)
		_:
			pass
	pass

func SwitchState(behaviorState: BehaviorState, loop: bool = false):
	if not loop and _currentState == behaviorState:
		return
	ExecuteState(StateExecutionType.Exit)
	_currentState = behaviorState
	ExecuteState(StateExecutionType.Enter)

func IdleState(stateExecutionType: StateExecutionType):
	pass
	
func MoveState(stateExecutionType: StateExecutionType):
	pass

func FallState(stateExecutionType: StateExecutionType):
	pass
	
func AttackState(stateExecutionType: StateExecutionType):
	pass
	
func SpecialState(stateExecutionType: StateExecutionType):
	pass
	
func DamagedState(stateExecutionType: StateExecutionType):
	pass
