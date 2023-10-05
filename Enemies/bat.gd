extends CharacterBody2D

@onready var stats = $Stats

const EnemyDeathEffect = preload("res://Effects/enemy_death_effect.tscn")

func _physics_process(delta):
	# Knockback
	velocity = velocity.move_toward(Vector2.ZERO, 200 * delta)
	move_and_slide()

func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
	velocity = area.knockback_direction * 120

func _on_stats_no_health():
	queue_free()
	var enemy_death_effect = EnemyDeathEffect.instantiate()
	get_parent().add_child(enemy_death_effect)
	enemy_death_effect.global_position = position
