extends CharacterBody2D

@export var acceleration : float = 150
@export var max_speed : float = 35
@export var friction : float = 50

@onready var stats = $Stats
@onready var player_detection_zone = $PlayerDetectionZone
@onready var animated_sprite = $AnimatedSprite2D

const EnemyDeathEffect = preload("res://Effects/enemy_death_effect.tscn")

enum {
	IDLE,
	WANDER,
	CHASE
}

var state = IDLE

func _physics_process(delta):
	# Knockback
	velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	move_and_slide()

	match state:
		IDLE:
			velocity =  velocity.move_toward(Vector2.ZERO,  friction * delta)
			seek_player()
		WANDER:
			pass
		CHASE:
			var target = player_detection_zone.target
			if target != null:
				var target_direction = (target.global_position - global_position).normalized()
				velocity = velocity.move_toward(target_direction * max_speed, acceleration * delta)
			else:
				state = IDLE
			animated_sprite.flip_h = velocity.x < 0
			
	move_and_slide()

func seek_player():
	if player_detection_zone.target_seen():
		state = CHASE

func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
	velocity = area.knockback_direction * 50

func _on_stats_no_health():
	queue_free()
	var enemy_death_effect = EnemyDeathEffect.instantiate()
	get_parent().add_child(enemy_death_effect)
	enemy_death_effect.global_position = position
