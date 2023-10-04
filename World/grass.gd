extends Sprite2D

func create_grass_effect():
	var GrassEffect = load("res://Effects/grass_effect.tscn")
	var grass_effect = GrassEffect.instantiate()
	var world = get_tree().current_scene
	world.add_child(grass_effect)
	grass_effect.global_position = global_position

func _on_hurtbox_area_entered(area):
	create_grass_effect()
	queue_free()
