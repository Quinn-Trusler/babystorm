extends Node2D

@export var attack_hang_time: float = 0.1

@onready var attack_duration_timer: Timer = $AttackDurationTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attack_duration_timer.wait_time = attack_hang_time
	attack_duration_timer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	pass


func _on_attack_duration_timer_timeout() -> void:
	queue_free()
