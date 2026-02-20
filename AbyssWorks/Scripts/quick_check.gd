extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignal.projectile_damage_registered.connect(self._projectile_damage_registered)
	pass # Replace with function body.

	
func _projectile_damage_registered(projectile: Node2D, collided: Node2D, damageInfo: DamageInfo):
	#print(projectile, " ", collided, " ", damageInfo)
	pass
