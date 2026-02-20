extends Node

#other options
const FIRE_ABILITY = "fire secondary"
const ICE_ABILITY = "ice secondary"
const STRENGTH_ABILITY = "strong main" 



var main_arm_body_part = "default main"
var secondary_arm_body_part = "default secondary"
var scene_index = 0
var scenes = ["res://AbyssWorks/Scenes/AbyssSceneLuchadorBoss.tscn",
	"res://AbyssWorks/Scenes/AbyssScene.tscn",
"res://Graeme/Scenes/Bosses/FireBoss/fire_boss_scene.tscn",
"res://AbyssWorks/Scenes/AbyssScenePhysicalBoss.tscn",
"res://Quinn/win_screen.tscn"]
var scene_unlocks = ["strength","ice", "fire", "big strong"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
func unlock():
	if scene_unlocks[scene_index] == "fire":
		secondary_arm_body_part = FIRE_ABILITY
	elif scene_unlocks[scene_index] == "ice":
		secondary_arm_body_part = ICE_ABILITY
	elif scene_unlocks[scene_index] == "strength":
		main_arm_body_part = STRENGTH_ABILITY
func get_scene_unlock():
	return scene_unlocks[scene_index]
	
#triggered by transition scene
func next_scene():
	unlock()
	scene_index +=1
func get_scene_name():
	return scenes[scene_index]
