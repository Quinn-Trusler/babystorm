extends Area2D
class_name ShootProjectile

@export var force: float = 100;
@export var destroyTimer: float = 3;

var instigator: Node2D = null
var shootDirection: Vector2 = Vector2.RIGHT

var damageInfo: DamageInfo = DamageInfo.new()
var forceInfo: ForceInfo = ForceInfo.new()

var _hitCalc: HitCalculator = HitCalculator.new()

var _customForce2D: CustomForce2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rotate(shootDirection.angle())
	
	area_entered.connect(self._on_area_entered)
	body_entered.connect(self._on_body_entered)
	
	_customForce2D = CustomForce2D.new()
	_customForce2D.gravity_scale = 0
	_customForce2D.air_drag = 0
	_customForce2D.AddForce(shootDirection * force, CustomForce2D.ForceMode.Impulse)
	await get_tree().create_timer(destroyTimer).timeout
	queue_free()
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	position += _customForce2D.velocity * delta
	_customForce2D._simulate_forces(false, delta)
	pass

func _on_area_entered(_area2D: Area2D) -> void:
	queue_free()
	pass

func _on_body_entered(body: Node2D) -> void:
	if body == instigator:
		return
	
	if body is CharacterBase:
		#print(body.global_position, " ", Hit.new().calculateHit2D(self, body))
	
		var characterBase: CharacterBase = body
		damageInfo.instigator = instigator
		
		var hit: HitCalculator.Hit2D = _hitCalc.calculateHit2D(self, body)
		
		if hit != null:
			damageInfo.hitPoint = hit.hit_point
			damageInfo.hitNormal = hit.hit_normal
		
		characterBase.ApplyDamageAndForce(damageInfo, forceInfo)
		GlobalSignal.projectile_damage_registered.emit(self, body, damageInfo)
			
	queue_free()
	pass
