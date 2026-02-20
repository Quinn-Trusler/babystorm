extends Ability
class_name IceProjectileAbility

@export_range(1, 100) var consecutiveHits: int = 1
@export var attackDistance: float = 400
@export var iceAttackAnims: Array[String] = []

@export_group("Projectile control")
@export var targetTrack: bool = false
@export var projectileForce: float = 200

@export_group("Damage")
@export var damageAmount: float = 0
@export var damageType: DamageInfo.DamageType = DamageInfo.DamageType.Ice

var spawn_dict: Dictionary[String, Node2D] = {}

var characterBody2D: CharacterBody2D = null
var anim_subsc: AnimationSubscriber = null
var target: Node2D = null

var _cooldownTimer: float = 0
var isExecuting: bool = false

var _consecutiveCount: int = 1

var spawnLocation: Node2D = null

const ICE_PROJECTILE_ATTACK = preload("res://AbyssWorks/Prefabs/Projectiles/IceShootProjectile.tscn")

func External_Ready() -> void:
	damageAmount = AbilityDamageAmount.iceProjectileDamage
	
	characterBody2D = _variable_dict["char_body"]
	anim_subsc = _variable_dict["anim_subsc"]
	spawn_dict = _variable_dict["spawn_dict"]
	target = _variable_dict["target"]
	
	spawnLocation = spawn_dict["IceProjectileSP"]
	
	if anim_subsc:
		anim_subsc.SubscribeCallable("Launch", self._spawn_on_current_anim)
	
	if not allowFirst:
		_cooldownTimer = cooldownTime
	
	pass
	
func IsExecuting():
	return isExecuting
	
func CanTrigger():
	return not isExecuting and _cooldownTimer <= 0
	
func Trigger():
	if (anim_subsc and iceAttackAnims.size() > 0):
		isExecuting = true
		_cooldownTimer = cooldownTime
		_consecutiveCount = 1
		anim_subsc.play(iceAttackAnims.pick_random())
	pass
	
func ExecutionCancel():
	isExecuting = false
	pass
	
func CheckRequirements(distance: float) -> bool:
	return distance <= attackDistance
	
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
			
	if not anim_subsc.is_playing():
		if _consecutiveCount >= consecutiveHits:
			isExecuting = false
			return
		_consecutiveCount+=1
		anim_subsc.play(iceAttackAnims.pick_random())
	
	pass
	
func _condition_cooldown(delta):
	if tickWhileExecuting:
		_cooldownTimer = maxf(_cooldownTimer - delta, 0)
	else:
		_cooldownTimer = cooldownTime
		
func _spawn_on_current_anim():
	if isExecuting:
		_spawn_projectile(spawnLocation)

func _spawn_projectile(spawnPoint: Node2D):
	if not characterBody2D and not spawnPoint:
		return
	
	var shoot_projectile_attack_instance = ICE_PROJECTILE_ATTACK.instantiate()
	if shoot_projectile_attack_instance is ShootProjectile:
		var shoot_projectile: ShootProjectile = shoot_projectile_attack_instance
		shoot_projectile.instigator = characterBody2D
		shoot_projectile.damageInfo = DamageInfo.new(damageAmount, characterBody2D, damageType)
		shoot_projectile.force = projectileForce
		shoot_projectile.global_position = spawnPoint.global_position
		if targetTrack and target:
			shoot_projectile.shootDirection = (target.global_position - characterBody2D.global_position).normalized()
		else:
			shoot_projectile.shootDirection = characterBody2D.transform.x
		
	characterBody2D.get_tree().current_scene.add_child(shoot_projectile_attack_instance)
	
	pass
