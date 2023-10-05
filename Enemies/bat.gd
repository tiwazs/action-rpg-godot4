extends CharacterBody2D

func _physics_process(delta):
	# Knockback
	velocity = velocity.move_toward(Vector2.ZERO, 200 * delta)
	move_and_slide()

func _on_hurtbox_area_entered(area):
	velocity = area.knockback_direction * 120
