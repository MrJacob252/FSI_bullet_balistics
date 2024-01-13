extends Area3D

func _process(delta):
	pass

func _on_body_exited(body):
	# If bullet exits the bounding box -> remove instanece
	#print(body, "body exited bounding box")
	body.queue_free()
