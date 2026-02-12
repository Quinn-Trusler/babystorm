extends CharacterBody2D

signal on_toggle_move(is_moving: bool)
signal on_item_picked_up(body_part: String)

@onready var legs: Node2D = $Legs
@onready var torso: Node2D = $Torso

const JUMP_VELOCITY = -400.0

var move_direction: float = 0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if move_direction:
		velocity.x = move_direction * legs.speed
	else:
		velocity.x = move_toward(velocity.x, 0, legs.speed)
	
	move_and_slide()
	
func item_picked_up(body_part):
	item_picked_up(body_part)

func _input(event):
	if event.is_action_pressed("ui_left"):
		move_direction = -1
		on_toggle_move.emit(true)
	elif event.is_action_pressed("ui_right"):
		move_direction = 1
		on_toggle_move.emit(true)
		
	if event.is_action_released("ui_left") or event.is_action_released("ui_right"):
		move_direction = 0
		on_toggle_move.emit(false)
		
	if event.is_action_pressed("ui_accept") and is_on_floor():
		velocity.y = legs.jump_velocity

		
func take_damage(damage: int):
	torso.health -= damage
	if torso.health <= 0:
		print("you have died :()")
