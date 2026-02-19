extends Node2D
class_name IceHailStorm

@export var edgeOffset: float = 30
@export var spawnDestroyTimer: float = 20

var instigator: Node2D
var damageInfo: DamageInfo = DamageInfo.new()

var forceMin: float = 150
var forceMax: float = 300

var effectDuration: float = 10
var spawnInterval: float = 2
var spawnFirstIce: bool = true


const ICE_PROJECTILE_ATTACK = preload("res://AbyssWorks/Prefabs/Projectiles/IceShootProjectile.tscn")

var _spawnCountdown: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if spawnFirstIce:
		_randomIceSpawn()
	
	await get_tree().create_timer(effectDuration).timeout
	queue_free()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if _spawnCountdown >= spawnInterval:
		_spawnCountdown = 0
		_randomIceSpawn()
	
	_spawnCountdown += delta
	pass
	
func get_view_bounds() -> Dictionary:
	var viewport = get_viewport()
	var camera = viewport.get_camera_2d()
	var rect = viewport.get_visible_rect()

	var left: float
	var right: float
	var top: float
	var bottom: float
	
	if camera:
		# 1. Adjust screen size by camera zoom
		var view_size = rect.size / camera.zoom
		# 2. Get the center point of the camera in world coordinates
		var center = camera.get_screen_center_position()

		left = center.x - (view_size.x / 2.0)
		right = center.x + (view_size.x / 2.0)
		top = center.y - (view_size.y / 2.0)
		bottom = center.y + (view_size.y / 2.0)
	else:
		# Default viewport starting at (0,0)
		left = 0.0
		right = rect.size.x
		top = 0.0
		bottom = rect.size.y
		
	return {
		"left": left,
		"right": right,
		"top": top,
		"bottom": bottom
   	}

func _randomIceSpawn():
	var viewBounds: Dictionary = get_view_bounds()
	var leftExtent: float = viewBounds["left"] + edgeOffset
	var rightExtent: float = viewBounds["right"] - edgeOffset
	var topExtent: float = viewBounds["top"] - edgeOffset
	
	#var randX: float = randf_range(spawnNodeXMin.global_position.x, spawnNodeXMax.global_position.x)
	var randX: float = randf_range(leftExtent, rightExtent)
	var spawnPoint: Vector2 = Vector2(randX, topExtent)
	_spawnIceProjectile(spawnPoint)

func _spawnIceProjectile(spawnPoint: Vector2):
	var shoot_projectile_attack_instance = ICE_PROJECTILE_ATTACK.instantiate()
	if shoot_projectile_attack_instance is ShootProjectile:
		var shoot_projectile: ShootProjectile = shoot_projectile_attack_instance
		shoot_projectile.instigator = instigator
		shoot_projectile.damageInfo = damageInfo
		shoot_projectile.force = randf_range(forceMin, forceMax)
		shoot_projectile.global_position = spawnPoint
		shoot_projectile.destroyTimer = spawnDestroyTimer
		shoot_projectile.shootDirection = transform.y
		
	get_tree().current_scene.add_child(shoot_projectile_attack_instance)
	#print("did spawn?")
	pass
