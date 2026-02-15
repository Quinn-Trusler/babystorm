extends CanvasLayer

@export var powerup_on_win : String

# How it works:
# Use fade in to trigger
# When player presses continue it goes to a brand new scene and pases it data
# That new scene automatically does a fade out
var next_scene : String
var in_animation : bool = false


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("NextScene") and not in_animation:# Letter n
		in_animation = true
		fade_in(["yada yada"],"res://Quinn/quinn_test_scene2.tscn")

func fade_in(powerups_owned, next_scene_):
	get_tree().paused = true
	next_scene = next_scene_
	visible = true
	$AnimationPlayer.play("fade_in")
	
func fade_out():
	$AnimationPlayer.play("fade_out")
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_in":
		$PowerupImage.play(powerup_on_win)
		$AnimationPlayer.play("fade_in_UI")
		print("fade in")
	if anim_name == "fade_out":
		visible = false

#func send_information(list_of_powerups : Array[String], new_powerup : String):
	
func _on_continue_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(next_scene)
	
