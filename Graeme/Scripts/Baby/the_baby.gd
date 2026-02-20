extends CharacterBase
class_name TheBaby

signal on_toggle_move(is_moving: bool)
signal on_change_direction(direction: int)
signal on_swapped_body_part(body_part: String)
signal on_health_changed(health)
signal on_toggle_jump(has_jumped)

@onready var legs: Node2D = $Legs
@onready var torso: Node2D = $Torso
@onready var main_arm: Node2D = $MainArm
@onready var secondary_arm: Node2D = $SecondaryArm
@export var health_layer: CanvasLayer

const JUMP_VELOCITY = -400.0

var move_direction: float = 0

func _ready() -> void:
	if health_layer != null:
		health_layer.set_player_max_health(torso.health)
	set_body_parts(GameManager.main_arm_body_part, GameManager.secondary_arm_body_part)

func set_body_parts(main_body_part, secondary_body_part):
	swap_body_part(main_body_part)
	swap_body_part(secondary_body_part)

# returns array of string of body parts. first is main arm and second is secondary arm
func get_body_parts():
	return [main_arm.current_type, secondary_arm.current_type]

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	
	if move_direction:
		velocity.x = move_direction * legs.speed
	else:
		velocity.x = move_toward(velocity.x, 0, legs.speed)
	
	move_and_slide()
	
func swap_body_part(body_part):
	on_swapped_body_part.emit(body_part)

var secondary_arm_testing_count = 0
var main_arm_testing_count = 0
var testing = false

func _input(event):
	# movement animations
	if event.is_action_pressed("move_left"):
		move_direction = -1
		#rotation = deg_to_rad(180)
		on_toggle_move.emit(true)
		on_change_direction.emit(-1)
	elif event.is_action_pressed("move_right"):
		move_direction = 1
		rotation = deg_to_rad(0)
		on_toggle_move.emit(true)
		on_change_direction.emit(1)
		
	if event.is_action_released("move_left") or event.is_action_released("move_right"):
		move_direction = 0
		on_toggle_move.emit(false)
		
	if (event.is_action_pressed("ui_accept") or event.is_action_pressed("jump")) and is_on_floor():
		velocity.y = legs.jump_velocity
		on_toggle_jump.emit(true)
		
		
	# Attack animations
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("Left mouse button pressed!")
			main_arm.attack()
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			print("Right mouse button pressed!")
			secondary_arm.attack()
			
	if event is InputEventKey and event.pressed and testing:
		if event.keycode == KEY_E:
			if secondary_arm_testing_count == 0:
				swap_body_part("ice secondary")
			elif secondary_arm_testing_count == 1:
				swap_body_part("fire secondary")
			else: 
				swap_body_part("default secondary")
			secondary_arm_testing_count += 1
		if event.keycode == KEY_F:
			if main_arm_testing_count == 0:
				swap_body_part("strong main")
			elif main_arm_testing_count == 1:
				swap_body_part("default main")
			
			main_arm_testing_count += 1
		
func ApplyDamageAndForce(damageInfo: DamageInfo, forceInfo: ForceInfo):
	print("Apply damage and force to player")
	print(damageInfo.amount)
	take_damage(damageInfo.amount)
		
func take_damage(damage: int):
	$hurtSound.play()
	torso.take_damage(damage)
	if health_layer != null:
		health_layer.update_player_health_bar(torso.health)
	on_health_changed.emit(torso.health)
	if torso.health <= 0:
		TransitionScreen.play_death()
		get_tree().reload_current_scene()
		
func get_health():
	return torso.health
