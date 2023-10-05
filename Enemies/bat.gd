extends CharacterBody2D

@onready var stats = $Stats

func _physics_process(delta):
	# Knockback
	velocity = velocity.move_toward(Vector2.ZERO, 200 * delta)
	move_and_slide()

func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
	velocity = area.knockback_direction * 120

func _on_stats_no_health():
	queue_free()
