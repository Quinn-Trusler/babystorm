@tool
extends Node2D

@export var metaDataOwner: Node2D = null
@export var metaDataName: String = ""
@export var isSelfModulate: bool = true

@export var hitbox: Hitbox = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:	
	if not hitbox:
		if metaDataOwner and metaDataOwner.has_meta(metaDataName):
			var value = metaDataOwner.get_meta(metaDataName)
			if value != null:
				if isSelfModulate:
					self_modulate = value
				else:
					modulate = value
	else:
		if hitbox.metaDataOwner and hitbox.metaDataOwner.has_meta(hitbox.metaDataName):
			var value = hitbox.metaDataOwner.get_meta(hitbox.metaDataName)
			if value != null:
				if hitbox.isSelfModulate:
					hitbox.self_modulate = value
				else:
					hitbox.modulate = value
	pass
