extends CharacterBase

@export var SPEED: float = 300.0
@export var attackTime: float = 10
@export var hitboxes: Array[Hitbox] = []
@export var customForce2D: CustomForce2D

@export_group("Movement stamina")
@export var maxStamina: float = 10
@export var staminaRecFactor: float = 1
@export var staminaDepFactor: float = 2
@export var staminaThreshold_min: float = 3
@export var staminaThreshold_max: float = 8

@export_group("Target")
@export var target: Node2D = null
@export var nearDistanceToTarget: float = 10

@export_group("Animations")
@export var idleAnim: String = ""
@export var moveAnim: String = ""
@export var fallAnim: String = ""

@export_group(("Abilities"))
@export var abilities: Array[Ability] = []

var isGrounded: bool;
var rotateDirection: Vector2 = Vector2.RIGHT
var _customForce2D: CustomForce2D = null

var _target_direction: Vector2 = Vector2.ZERO
var _target_hori_direction: float = 0

var _deltaTime: float = 0
var _physicsDeltaTime: float = 0

var _cur_attack_time: float = 0

var _variable_dict: Dictionary = {}

var _abilities: Array[Ability] = []
var _cur_ability: Ability = null

var _cur_stamina: float = 0
var _cur_stamina_threshold: float = 0

@onready var anim_player: AnimationPlayer = $AnimationPlayer

const FLIP_X = Transform2D(Vector2(-1, 0), Vector2(0, 1), Vector2(0, 0))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (customForce2D):
		_customForce2D = customForce2D.duplicate(true)
		_customForce2D.node2D = self
	
	_variable_dict["anim_player"] = anim_player
	_variable_dict["anim_subsc"] = anim_player as AnimationSubscriber
	_variable_dict["custom_force"] = _customForce2D
	_variable_dict["char_body"] = self
	_variable_dict["node2d"] = self as Node2D
	_variable_dict["hitboxes"] = hitboxes
	
	for ability in abilities:
		if not ability:
			continue
		var _ability: Ability = ability.duplicate(true)
		_ability._variable_dict = _variable_dict
		_ability.External_Ready()
		_abilities.append(_ability)
	
	if target:
		_target_direction = target.global_position - global_position
		_target_hori_direction = sign(_target_direction.x)	
	
	_cur_attack_time = attackTime
	_cur_stamina = maxStamina
	_cur_stamina_threshold = randf_range(staminaThreshold_min, staminaThreshold_max)
	
	ExecuteState(StateExecutionType.Enter)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not visible:
		return
		
	_deltaTime = delta
	
	_cur_attack_time += delta
	
	if _cur_ability == null and _currentState != BehaviorState.Attack:
		#print(BehaviorState.keys()[_currentState])
		_cur_ability = _get_ability()
	
	ExecuteState(StateExecutionType.Update)
	
	for _ability in _abilities:
		if _ability:
			_ability.External_Process(_deltaTime)
	
	pass

func _physics_process(delta: float) -> void:
	if not visible:
		return
	
	_physicsDeltaTime = delta
	
	if _target_hori_direction != 0 and _currentState != BehaviorState.Attack:
		rotateDirection = Vector2.RIGHT * _target_hori_direction
		_flip_horizontal(_target_hori_direction)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if (_customForce2D):
		_customForce2D._simulate_forces(isGrounded, delta)
		velocity += _customForce2D.velocity
	
	ExecuteState(StateExecutionType.FixedUpdate)
	
	if target:
		_target_direction = target.global_position - global_position
		_target_hori_direction = sign(_target_direction.x)
		
	
	if (_customForce2D):
		_customForce2D._simulate_forces(isGrounded, delta)
		velocity += _customForce2D.velocity
	
	ExecuteState(StateExecutionType.FixedUpdate)
	
	for _ability in _abilities:
		if _ability:
			_ability.External_PhysicsProcess(_physicsDeltaTime)
	
	move_and_slide()
	
	pass
	
func _flip_horizontal(direction: float):
	var signedDir = sign(direction)
	var signedXTransform = sign(transform.x.x)
	if signedDir == 0 or signedXTransform == 0:
		return
	if signedDir != signedXTransform:
		transform = transform * FLIP_X
	pass
	
func _get_ability() -> Ability:
	var res_ability = null
	var index = null
	for i in range(_abilities.size()):
		var _ability: Ability = _abilities[i]
		if _ability.CanTrigger() and _ability.CheckRequirements(_target_direction.length()):
			res_ability = _ability
			index = i
			break
	
	if index != null:
		_abilities.remove_at(index)
		_abilities.append(res_ability)
	
	return res_ability

func IdleState(stateExecutionType: StateExecutionType):
	match stateExecutionType:
		StateExecutionType.Enter:
			if (anim_player):
				anim_player.play(idleAnim)
			pass
		StateExecutionType.Update:
			if _cur_ability:
				SwitchState(BehaviorState.Attack)
				return
				
			if _target_direction.length() > nearDistanceToTarget and _cur_stamina >= _cur_stamina_threshold:
				SwitchState(BehaviorState.Move)
				return
				
			velocity.x = move_toward(velocity.x, 0, SPEED)
			_cur_stamina = minf(_cur_stamina + staminaRecFactor * _deltaTime, maxStamina)
			pass
		_:
			pass
			
func MoveState(stateExecutionType: StateExecutionType):
	match stateExecutionType:
		StateExecutionType.Enter:
			if (anim_player and moveAnim != ""):
				anim_player.play(moveAnim)
			pass
		StateExecutionType.Exit:
			_cur_stamina_threshold = randf_range(staminaThreshold_min, staminaThreshold_max)
			pass
		StateExecutionType.Update:
			if _cur_ability:
				SwitchState(BehaviorState.Attack)
				return
				
			if _target_direction.length() <= nearDistanceToTarget or _cur_stamina <= 0:
				SwitchState(BehaviorState.Idle)
				return
			velocity.x = _target_hori_direction * SPEED
			
			_cur_stamina = maxf(_cur_stamina - staminaDepFactor * _deltaTime, 0)
			pass
		_:
			pass

func FallState(stateExecutionType: StateExecutionType):
	match stateExecutionType:
		StateExecutionType.Enter:
			if (anim_player and fallAnim != ""):
				anim_player.play(fallAnim)
			pass
		StateExecutionType.Update:
			pass
		_:
			pass

func AttackState(stateExecutionType: StateExecutionType):
	match stateExecutionType:
		StateExecutionType.Enter:
			if not _cur_ability:
				SwitchState(BehaviorState.Idle)
				return
			_cur_ability.Trigger()
			pass
		StateExecutionType.Exit:
			_cur_ability = null
			pass
		StateExecutionType.Update:
			if not _cur_ability.IsExecuting():
				SwitchState(BehaviorState.Idle)
				return
			pass
		_:
			pass

func ApplyDamageAndForce(damageInfo: DamageInfo, forceInfo: ForceInfo):
	if forceInfo and customForce2D:
		match forceInfo.ForceType:
			ForceInfo.ForceType.Normal:
				customForce2D.AddForce(forceInfo.force, forceInfo.forceMode)
				pass
			ForceInfo.ForceType.Explosion:
				customForce2D.AddExplosionForce(forceInfo.explosionForce, forceInfo.explosionPosition,
				forceInfo.explosionRadius, forceInfo.upwardsModifier, forceInfo.forceMode)
				pass
			ForceInfo.ForceType.Implosion:
				customForce2D.AddExplosionForce(-forceInfo.explosionForce, forceInfo.explosionPosition,
				forceInfo.explosionRadius, forceInfo.upwardsModifier, forceInfo.forceMode)
				pass
			_:
				pass		
	pass
