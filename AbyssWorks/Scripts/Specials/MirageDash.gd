extends Node2D
class_name MirageDash

@export var curve: Curve = Curve.new()
@export var hitbox: Hitbox = null

var move_speed: float = 500
var effect_duration: float = 1
var move_direction: Vector2 = Vector2.RIGHT


var instigator: Node2D = null

var damageInfo: DamageInfo = DamageInfo.new()

var _current_speed: float = 0
var _current_duration: float = 0

var _color: Color = Color()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if hitbox:
		hitbox.instigator = instigator
		hitbox.onModifyDamageAndForceInfo = self._modifyDamageAndForceInfo
		
	_current_speed = move_speed
	_current_duration = effect_duration
	_color = modulate
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if _current_duration <= 0:
		queue_free()
	
	var cur_perc: float = clampf(_current_duration / (effect_duration + 0.01), 0, 1)
	
	var sample_fac = curve.sample(1.0 - cur_perc)
	var calc_speed = sample_fac * move_speed
	
	position += move_direction * calc_speed * delta
	modulate.a = _color.a * sample_fac
	
	_current_duration = maxf(_current_duration - delta, 0)
	pass
	
func _modifyDamageAndForceInfo(_body: Node2D, damageInfo: DamageInfo, _forceInfo: ForceInfo):
	if damageInfo == null or self.damageInfo == null:
		return
	
	damageInfo.amount = self.damageInfo.amount
	damageInfo.damageType = self.damageInfo.damageType
	damageInfo.instigator = self.damageInfo.instigator
	pass
