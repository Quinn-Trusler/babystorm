@tool
extends Node2D

@export var metaDataOwner: Node2D = null
@export var metaDataName: String = ""
@export var isSelfModulate: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	if metaDataOwner and metaDataOwner.has_meta(metaDataName):
		var value = metaDataOwner.get_meta(metaDataName)
		if value != null:
			if isSelfModulate:
				self_modulate = value
			else:
				modulate = value
	pass
