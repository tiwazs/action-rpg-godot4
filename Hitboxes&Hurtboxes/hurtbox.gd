extends Area2D

@export var enable_hit_effect: bool = true

const HitEffect = preload("res://Effects/hit_effect.tscn")

func _on_area_entered(area):
	if enable_hit_effect:
		var effect = HitEffect.instantiate()
		var main = get_tree().current_scene
		main.add_child(effect)
		effect.global_position = global_position
