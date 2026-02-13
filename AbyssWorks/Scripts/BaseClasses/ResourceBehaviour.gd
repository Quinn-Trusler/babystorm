extends Resource
class_name ResourceBehaviour

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

func External_Ready() -> void:
	pass

func External_Process(delta: float) -> void:
	pass

func External_PhysicsProcess(delta: float) -> void:
	pass

func External_BodyEntered(body) -> void:
	pass
	
func External_BodyExited(body) -> void:
	pass
	
func External_AreaEntered(body) -> void:
	pass
	
func External_AreaExited(body) -> void:
	pass
