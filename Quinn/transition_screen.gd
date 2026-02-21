extends CanvasLayer

# How it works:
# Use fade in to trigger
# When player presses continue new scene is loaded
# After fade out new scene is unpaused

# ????? We could use global variabes to pass data or pass through this scene

var next_scene : String
var in_transition : bool = false
var play_animations_backwards = false


#func _process(_delta: float) -> void:
	#if Input.is_action_just_pressed("NextScene") and not in_transition:# Letter n
		#in_transition = true
		#fade_in()

func fade_in():
	play_animations_backwards = false
	get_tree().paused = true
	visible = true
	$PowerupImage.play(GameManager.get_scene_unlock())
	$PowerUpName.text = GameManager.get_scene_unlock() + " gene unlocked!"
	$AnimationPlayer.play("fade_in")
	$WinBossBattle.play()
	print("start fade in")
	
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
		GameManager.next_scene()
		get_tree().change_scene_to_file(GameManager.get_scene_name())
		fade_out()
		$WinBossBattle.stop()
		$Play.play()
func play_final():
	$Music1.stop()
	$Music2.play()
func play_win():
	$Music2.stop()
	$Win.play()
func play_death():
	$Death.play()
	
