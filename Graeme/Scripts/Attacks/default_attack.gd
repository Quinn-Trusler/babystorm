extends Node2D
class_name DefaultAttack

@export var attack_hang_time: float = 0.1

@onready var attack_duration_timer: Timer = $AttackDurationTimer

var instigator: Node2D = null
var damageInfo: DamageInfo = DamageInfo.new()
var forceInfo: ForceInfo = ForceInfo.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attack_duration_timer.wait_time = attack_hang_time
	attack_duration_timer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	pass


func _on_attack_duration_timer_timeout() -> void:
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == instigator:
		return	
	
	print(body)
	
	if body is CharacterBase:
		var characterBase: CharacterBase = body
		damageInfo.instigator = instigator
		
		characterBase.ApplyDamageAndForce(damageInfo, forceInfo)
	pass # Replace with function body.
