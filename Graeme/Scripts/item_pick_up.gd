extends Node2D

@export var item: Item


@onready var texture_rect: TextureRect = $RigidBody2D/TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	initialize(item)

func initialize(_item: Item):
	item = _item
	texture_rect.texture = item.texture
	#item_sprite.texture.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is TheBaby:
		body.item_picked_up(item.name)
		item_picked_up()

func item_picked_up():
	queue_free()
