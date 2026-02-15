extends ResourceBehaviour
class_name Ability

@export_group("Execution delay control")
@export var cooldownTime: float = 0
@export var allowFirst: bool = false
@export var tickWhileExecuting: bool = false
@export var usePhysicsDelta: bool = true

signal onExecutionComplete;

var _variable_dict: Dictionary = {}

func CanTrigger() -> bool:
	return true
	
func Trigger() -> void:
	pass

func TryTrigger() -> void:
	if CanTrigger():
		Trigger()

func ExecutionCancel() -> void:
	pass

func IsExecuting() -> bool:
	return false
	
func CheckRequirements(distance: float) -> bool:
	return true
