extends ResourceBehaviour
class_name Ability

signal onExecutionComplete;

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
