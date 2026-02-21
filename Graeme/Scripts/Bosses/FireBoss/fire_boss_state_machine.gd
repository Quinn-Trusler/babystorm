extends Node
class_name FireBossStateMachine

var current_state_index = 0
var current_state: BossAttackState

var states: Dictionary = {}


func _ready() -> void:
	define_states()
	
# adds all the childrem of this class to the state dictionary
# this allows switching between states easy
func define_states():
	for child in get_children():
		if child is BossAttackState:
			states[child.name.to_lower()] = child
			
			
	
	current_state = states[states.keys()[current_state_index]]
	current_state.enter()



func set_next_state():
	randomize()
	var r = randf()  # gives 0.0 → 1.0
	
	if r < 0.33:
		change_state(0)   # State 1 (70%)
	elif r < 0.66:
		change_state(1)   # State 2 (20%)
	else:
		change_state(2)# State 3 (10%)

func change_state(state = -1):

	if state < 0:
		var state_list = states.keys()
		current_state_index = (current_state_index + 1) % len(state_list)
	else:
		current_state_index = state
		
	current_state.exited()
	current_state = get_children()[current_state_index]
	current_state.enter()
	
	
func _process(delta: float) -> void:
	current_state.update(delta)
	
