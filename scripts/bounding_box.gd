extends Area3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_exited(body):
	#print(body, "body exited bounding box")
	body.queue_free()
