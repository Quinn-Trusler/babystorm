extends Projectile


var direction: int = -1
var velocity_scalar: float = 1000
var initial_velocity = Vector2(1.0, -0.3)
var rotation_speed = 20


@onready var projectile_sprite: Sprite2D = $ProjectileSprite

var instigator: Node2D = null
var damageInfo: DamageInfo = DamageInfo.new()
var forceInfo: ForceInfo = ForceInfo.new()

var _hitCalc: HitCalculator = HitCalculator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	damage_amount = 40

func set_direction(_direction: int):
	
	direction = _direction
	if direction < 0:
		projectile_sprite.rotation = deg_to_rad(135)
	set_projectile_velocity()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func set_projectile_velocity():
	
	linear_velocity.x = initial_velocity.x * float(direction) * velocity_scalar 
	linear_velocity.y = initial_velocity.y * velocity_scalar


func _on_despawn_timer_timeout() -> void:
	queue_free()


func _on_hit_area_2d_area_entered(area: Area2D) -> void:
	# does damage on enemy with area 2d
	pass


func _on_hit_area_2d_body_entered(body: Node2D) -> void:
	# does damage on enemy with rigid body
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
		
		characterBase.ApplyDamageAndForce(damage_amount, forceInfo)
		GlobalSignal.projectile_damage_registered.emit(self, body, damageInfo)
