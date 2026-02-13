extends AnimationPlayer
class_name AnimationSubscriber

class AnimCallable:
	var callables: Array[Callable] = []
	var count: int = 0

var endCount: int = 0
var endCallables: Array[Callable] = []

var startCount: int = 0
var startCallables: Array[Callable] = []

var callableDict: Dictionary = {}

func SubscribeEndCallable(callable: Callable):
	endCallables.append(callable)
func UnSubscribeEndCallable(callable: Callable):
	endCallables.erase(callable)
func ClearEndCallables():
	endCallables.clear()
	
func SubscribeStartCallable(callable: Callable):
	startCallables.append(callable)
func UnSubscribeStartCallable(callable: Callable):
	startCallables.erase(callable)
func ClearStartCallables():
	startCallables.clear()
	
func SubscribeCallable(callableName: String, callable: Callable):
	if not callableDict.has(callableName):
		callableDict[callableName] = AnimCallable.new()
	callableDict[callableName].callables.append(callable)
	
func UnSubscribeCallable(callableName: String, callable: Callable):
	if callableDict.has(callableName):
		callableDict[callableName].callables.erase(callable)

func ClearCallables(callableName: String):
	if callableDict.has(callableName):
		callableDict[callableName].callables.clear()

func TriggerAnimationEnd():
	endCount+=1
	InvokeCallables(endCallables)

func TriggerAnimationStart():
	startCount+=1
	InvokeCallables(startCallables)

func TriggerCallable(callableName: String):
	if callableDict.has(callableName):
		var animCallable = callableDict[callableName]
		animCallable.count += 1
		InvokeCallables(animCallable.callables)

func getCount(callableName: String) -> int:
	if callableDict.has(callableName):
		return callableDict[callableName].count
	return 0

func InvokeCallables(callables: Array[Callable]):
	for callable in callables:
		if (callable != null):
			callable.call()
			
func _exit_tree() -> void:
	ClearEndCallables()
	ClearStartCallables()
	callableDict.clear()
