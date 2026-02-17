extends CharacterBase

@export var SPEED: float = 300.0
@export var JUMP_VELOCITY: float = 400.0
@export var hitboxes: Array[Hitbox] = []
@export var customForce2D: CustomForce2D

@export_group("Animations")
@export var idleAnim: String = ""
@export var moveAnim: String = ""
@export var fallAnim: String = ""

@export_group(("Abilities"))
@export var basicPunchAbility: BasicPunchAbility
@export var gigaPunchRushAbility: GigaPunchRushAbility

var bulletRes = preload("res://AbyssWorks/Prefabs/BulletBall.tscn")

var isGrounded: bool;
var rotateDirection: Vector2 = Vector2.RIGHT
var _customForce2D: CustomForce2D = null

var _inputDirection: float = 0

var _deltaTime: float = 0
var _physicsDeltaTime: float = 0

var _basicPunch: BasicPunchAbility = null
var _gigaPunchRush: GigaPunchRushAbility = null

var _abilities: Array[Ability] = []
var _variable_dict: Dictionary = {}

var _moveVelocity: Vector2 = Vector2.ZERO

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
	
	if (basicPunchAbility):
		_basicPunch = basicPunchAbility.duplicate(true)
		_basicPunch._variable_dict = _variable_dict
		_basicPunch.External_Ready()
	
	if (gigaPunchRushAbility):
		_gigaPunchRush = gigaPunchRushAbility.duplicate(true)
		_gigaPunchRush._variable_dict = _variable_dict
		_gigaPunchRush.External_Ready()
		
	_abilities.append(_basicPunch)
	_abilities.append(_gigaPunchRush)
	
	ExecuteState(StateExecutionType.Enter)
	
	pass # Replace with function body.

func _process(delta: float) -> void:
	if not visible:
		return
	
	_deltaTime = delta
	
	if Input.is_action_just_pressed("ui_accept") and isGrounded:
		_customForce2D.AddForce(Vector2.UP * JUMP_VELOCITY, CustomForce2D.ForceMode.Impulse)
		
	if Input.is_action_just_pressed('Shoot'):
		'''
		var bulletInstance = bulletRes.instantiate()
		bulletInstance.moveDirection = rotateDirection
		bulletInstance.instigator = self
		bulletInstance.global_position = global_position
		get_tree().current_scene.add_child(bulletInstance)
		'''
		SwitchState(BehaviorState.Attack)
		
	if Input.is_action_just_pressed("Special"):
		if _gigaPunchRush != null and _gigaPunchRush.CanTrigger():
			SwitchState(BehaviorState.Special)
		#print(bulletInstance.position, 'position', self)
	ExecuteState(StateExecutionType.Update)
	
	for _ability in _abilities:
		if _ability:
			_ability.External_Process(_deltaTime)
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not visible:
		return
	
	_physicsDeltaTime = delta	
	
	isGrounded = is_on_floor()
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	_inputDirection = Input.get_axis("ui_left", "ui_right")
	
	if _inputDirection != 0 and _currentState != BehaviorState.Special:
		rotateDirection = Vector2.RIGHT * _inputDirection
		#transform.x = Vector2(_inputDirection, 0.0)
		_flip_horizontal(_inputDirection)
	else:
		_moveVelocity = Vector2(move_toward(velocity.x, 0, SPEED), 0)
		_move_character(_moveVelocity)
	
	ExecuteState(StateExecutionType.FixedUpdate)
	
	for _ability in _abilities:
		if _ability:
			_ability.External_PhysicsProcess(_physicsDeltaTime)
		
	if (_customForce2D):
		_customForce2D._simulate_forces(isGrounded, delta)
		_move_character(_customForce2D.velocity)
		
	pass

func _flip_horizontal(direction: float):
	var signedDir = sign(direction)
	var signedXTransform = sign(transform.x.x)
	if signedDir == 0 or signedXTransform == 0:
		return
	if signedDir != signedXTransform:
		transform = transform * FLIP_X
	pass
	
func IdleState(stateExecutionType: StateExecutionType):
	match stateExecutionType:
		StateExecutionType.Enter:
			if (anim_player):
				anim_player.play(idleAnim)
			pass
		StateExecutionType.Update:
			if _inputDirection != 0:
				SwitchState(BehaviorState.Move)
				return
			
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
			if _inputDirection == 0:
				SwitchState(BehaviorState.Idle)
				return
			_moveVelocity = Vector2(_inputDirection * SPEED, 0)
			_move_character(_moveVelocity)
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
			if (_gigaPunchRush and _gigaPunchRush.IsExecuting()):
				_gigaPunchRush.ExecutionCancel()
			if (_basicPunch and _basicPunch.CanTrigger()):
				_basicPunch.Trigger()
				pass
			else:
				SwitchState(BehaviorState.Idle)
			pass
		StateExecutionType.Update:
			if (_basicPunch):
				if not _basicPunch.IsExecuting():
					SwitchState(BehaviorState.Idle)
			else:
				SwitchState(BehaviorState.Idle)
			pass
		_:
			pass
			
func SpecialState(stateExecutionType: StateExecutionType):
	match stateExecutionType:
		StateExecutionType.Enter:
			if _basicPunch and _basicPunch.IsExecuting():
				_basicPunch.ExecutionCancel()
			
			if _gigaPunchRush:
				_gigaPunchRush.Trigger()
			pass
		StateExecutionType.Update:
			if _gigaPunchRush:
				if not _gigaPunchRush.IsExecuting():
					SwitchState(BehaviorState.Idle)
			else:
				SwitchState(BehaviorState.Idle)
			pass
		StateExecutionType.FixedUpdate:
			pass
		_:
			pass
