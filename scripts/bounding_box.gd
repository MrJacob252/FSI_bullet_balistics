extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_exited(area):
	print(area, "area exited bounding box")
	area.queue_free()


func _on_body_exited(body):
	print(body, "body exited bounding box")
	body.queue_free()
