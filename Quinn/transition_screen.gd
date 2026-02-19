extends CanvasLayer

# How it works:
# Use fade in to trigger
# When player presses continue new scene is loaded
# After fade out new scene is unpaused

# ????? We could use global variabes to pass data or pass through this scene

var next_scene : String
var in_transition : bool = false
var play_animations_backwards = false


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("NextScene") and not in_transition:# Letter n
		in_transition = true
		fade_in(["fire", "strength"],"ice","res://Quinn/quinn_test_scene2.tscn")

func fade_in(powerups_owned, new_powerup, next_scene_):
	play_animations_backwards = false
	get_tree().paused = true
	next_scene = next_scene_
	visible = true
	$PowerupImage.play(new_powerup)
	$PowerUpName.text = new_powerup + " gene unlocked!"
	$AnimationPlayer.play("fade_in")
	
func fade_out():
	play_animations_backwards = true
	$AnimationPlayer.play_backwards("fade_in")
	print("fade out", play_animations_backwards)
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	print("animation finished")
	if anim_name == "fade_in":
		if play_animations_backwards:
			$AnimationPlayer.play_backwards("fade_in_UI")
		else:
			$AnimationPlayer.play("fade_in_UI")
	if anim_name == "fade_in_UI" and play_animations_backwards == true:
		visible = false
		in_transition = false
		get_tree().paused = false

	
func _on_continue_button_pressed() -> void:
	if not play_animations_backwards:
		get_tree().change_scene_to_file(next_scene)
		fade_out()
	
