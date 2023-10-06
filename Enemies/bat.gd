extends CharacterBody2D

@export var acceleration : float = 150
@export var max_speed : float = 35
@export var friction : float = 50
@export var wander_taget_tolerance : float = 4

@onready var stats = $Stats
@onready var player_detection_zone = $PlayerDetectionZone
@onready var animated_sprite = $AnimatedSprite2D
@onready var hurtbox = $Hurtbox
@onready var soft_collision = $SoftCollision
@onready var wander_controller = $WanderController

const EnemyDeathEffect = preload("res://Effects/enemy_death_effect.tscn")

enum {
	IDLE,
	WANDER,
	CHASE
}

var state = IDLE

func _ready():
	state = pick_random_state([IDLE, WANDER])

func _physics_process(delta):
	# Knockback
	velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	move_and_slide()

	match state:
		IDLE:
			velocity =  velocity.move_toward(Vector2.ZERO,  friction * delta)
			seek_player()
			
			if wander_controller.get_time_left() == 0:
				state = pick_random_state([IDLE, WANDER])
				wander_controller.start_wander_timer(randf_range(1,3))
		WANDER:
			seek_player()
			if wander_controller.get_time_left() == 0:
				state = pick_random_state([IDLE, WANDER])
				wander_controller.start_wander_timer(randf_range(1,3))
			
			var target_direction = global_position.direction_to(wander_controller.target_position)
			velocity = velocity.move_toward(target_direction * max_speed, acceleration * delta)
			
			animated_sprite.flip_h = velocity.x < 0
			
			if global_position.distance_to(wander_controller.target_position) <= wander_taget_tolerance:
				state = pick_random_state([IDLE, WANDER])
				wander_controller.start_wander_timer(randf_range(1,3))
		CHASE:
			var target = player_detection_zone.target
			if target != null:
				var target_direction = global_position.direction_to(target.global_position)
				velocity = velocity.move_toward(target_direction * max_speed, acceleration * delta)
			else:
				state = IDLE
			animated_sprite.flip_h = velocity.x < 0
	if soft_collision.is_colliding():
		velocity += soft_collision.get_push_vector() * delta * 400
	move_and_slide()

func seek_player():
	if player_detection_zone.target_seen():
		state = CHASE

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
	velocity = area.knockback_direction * 50
	hurtbox.create_hit_effect()

func _on_stats_no_health():
	queue_free()
	var enemy_death_effect = EnemyDeathEffect.instantiate()
	get_parent().add_child(enemy_death_effect)
	enemy_death_effect.global_position = position
