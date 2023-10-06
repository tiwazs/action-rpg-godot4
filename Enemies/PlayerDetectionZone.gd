extends Area2D

var target = null

func target_seen():
	return target != null

func _on_body_entered(body):
	target = body

func _on_body_exited(body):
	target = null
