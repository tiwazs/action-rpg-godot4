extends Sprite2D

func _process(delta):
	if Input.is_action_just_pressed("attack"):
		var GrassEffect = load("res://Effects/grass_effect.tscn")
		var grass_effect = GrassEffect.instantiate()
		var world = get_tree().current_scene
		world.add_child(grass_effect)
		grass_effect.global_position = global_position
		
		queue_free()
