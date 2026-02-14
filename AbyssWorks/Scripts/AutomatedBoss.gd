extends CharacterBody2D

enum StateExecutionType { Enter, Update, FixedUpdate, Exit }
enum BossState { Idle, Move, Fall, Attack, Special }

@export var SPEED: float = 300.0
@export var attackTime: float = 10
@export var customForce2D: CustomForce2D

@export_group("Target")
@export var target: Node2D = null
@export var nearDistanceToTarget: float = 10

@export_group("Animations")
@export var idleAnim: String = ""
@export var moveAnim: String = ""
@export var fallAnim: String = ""
@export var basicAttackAnims: Array[String] = []

@export_group(("Abilities"))
@export var gigaPunchRushAbility: GigaPunchRushAbility

var isGrounded: bool;
var rotateDirection: Vector2 = Vector2.RIGHT
var _customForce2D: CustomForce2D = null

var _currentState: BossState = BossState.Idle
var _target_direction: Vector2 = Vector2.ZERO
var _target_hori_direction: float = 0

var _deltaTime: float = 0
var _physicsDeltaTime: float = 0

var _cur_attack_time: float = 0

var _gigaPunchRush: GigaPunchRushAbility = null

@onready var anim_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (customForce2D):
		_customForce2D = customForce2D.duplicate(true)
		_customForce2D.node2D = self
	
	if (gigaPunchRushAbility):
		_gigaPunchRush = gigaPunchRushAbility.duplicate(true)
		_gigaPunchRush.animationSubscriber = anim_player as AnimationSubscriber
		_gigaPunchRush.customForce2D = _customForce2D
		_gigaPunchRush.characterBody2D = self
		_gigaPunchRush.External_Ready()
	
	if target:
		_target_direction = target.global_position - global_position
		_target_hori_direction = sign(_target_direction.x)	
	
	_cur_attack_time = attackTime
	
	ExecuteState(StateExecutionType.Enter)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not visible:
		return
		
	_deltaTime = delta
	
	_cur_attack_time += delta
	
	ExecuteState(StateExecutionType.Update)
	
	pass

func _physics_process(delta: float) -> void:
	if not visible:
		return
	
	_physicsDeltaTime = delta
	
	if _target_hori_direction != 0 and _currentState != BossState.Special:
		rotateDirection = Vector2.RIGHT * _target_hori_direction
		transform.x = Vector2(_target_hori_direction, 0.0)
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
	
	#print(_target_direction.length(), " ", nearDistanceToTarget)
	
	move_and_slide()
	
	pass

func ExecuteState(stateExecutionType: StateExecutionType):
	match _currentState:
		BossState.Idle:
			IdleState(stateExecutionType)
		BossState.Move:
			MoveState(stateExecutionType)
		BossState.Fall:
			FallState(stateExecutionType)
		BossState.Attack:
			AttackState(stateExecutionType)
		BossState.Special:
			SpecialState(stateExecutionType)
		_:
			pass
	pass

func SwitchState(bossState: BossState, loop: bool = false):
	if not loop and _currentState == bossState:
		return
	ExecuteState(StateExecutionType.Exit)
	_currentState = bossState
	ExecuteState(StateExecutionType.Enter)

func IdleState(stateExecutionType: StateExecutionType):
	match stateExecutionType:
		StateExecutionType.Enter:
			if (anim_player):
				anim_player.play(idleAnim)
			pass
		StateExecutionType.Update:
			if _target_direction.length() > nearDistanceToTarget:
				SwitchState(BossState.Move)
				return
				
			if _cur_attack_time >= attackTime:
				_cur_attack_time = 0
				SwitchState(BossState.Attack)
				return
				
			velocity.x = move_toward(velocity.x, 0, SPEED)
			pass
		_:
			pass
			
func MoveState(stateExecutionType: StateExecutionType):
	match stateExecutionType:
		StateExecutionType.Enter:
			if (anim_player and moveAnim != ""):
				anim_player.play(moveAnim)
			pass
		StateExecutionType.Update:
			if _target_direction.length() <= nearDistanceToTarget:
				SwitchState(BossState.Idle)
				return
			velocity.x = _target_hori_direction * SPEED
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
			if (anim_player and basicAttackAnims.size() > 0):
				anim_player.play(basicAttackAnims.pick_random())
				pass
			else:
				SwitchState(BossState.Idle)
			pass
		StateExecutionType.Update:
			if (!anim_player.is_playing()):
				SwitchState(BossState.Idle)
			pass
		_:
			pass
			
func SpecialState(stateExecutionType: StateExecutionType):
	match stateExecutionType:
		StateExecutionType.Enter:
			if _gigaPunchRush:
				_gigaPunchRush.dashDirection = rotateDirection.x
				_gigaPunchRush.Trigger()
			pass
		StateExecutionType.Update:
			if _gigaPunchRush:
				if not _gigaPunchRush.IsExecuting():
					SwitchState(BossState.Idle)
			else:
				SwitchState(BossState.Idle)
			pass
		StateExecutionType.FixedUpdate:
			if _gigaPunchRush:
				_gigaPunchRush.External_PhysicsProcess(_physicsDeltaTime)
		_:
			pass
