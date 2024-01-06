extends RigidBody3D

@onready var bullet_cam = $bullet_cam

# consts
const SPEED: int = 0.9

# vars
var shoot: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# When created as a child it instantly becomes it's own object so it can't 
	# be controlled by the changes in parrent
	set_as_top_level(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if shoot:
		#apply_impulse(transform.basis.z, -transform.basis.z)
		apply_impulse(-transform.basis.z * 0.5, transform.basis.z)
		


func _on_area_3d_body_entered(body):
	if body.is_in_group("Target"):
		queue_free()
	else:
		queue_free()
		
	print("bullet colided with:", body)
		
func activate_cam():
	bullet_cam.make_current()

