extends Node2D

@export var wander_range : int = 32

@onready var start_position = global_position
@onready var target_position = global_position
@onready var timer = $Timer

func _ready():
	update_target_position()

func update_target_position():
	var target_vector =  Vector2(randf_range(-wander_range, wander_range), randf_range(-wander_range, wander_range))
	target_position = start_position + target_vector

func start_wander_timer(duration):
	timer.start(duration)

func get_time_left():
	return timer.time_left

func _on_timer_timeout():
	update_target_position()
	