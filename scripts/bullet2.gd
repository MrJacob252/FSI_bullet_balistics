extends Area3D

@onready var bullet_cam = $bullet_cam
@onready var bullet = $"."

# consts


# vars
var impulse: float = Global.bullet_impulse
#var shoot: bool = false
var was_shot: bool = false

#var gravity: float = 9.8
#var gravity: float = 0.98
#var gravity: Vector3 = Vector3(0, -9.8, 0)
var damping: float = 0.99
var custom_force: Vector3 = Vector3.ZERO
var new_velocity: Vector3 = Vector3.ZERO

var g = Vector3.DOWN * 20

var local_transform: Transform3D = transform

# Called when the node enters the scene tree for the first time.
func _ready():
	# When created as a child it instantly becomes it's own object so it can't 
	# be controlled by the changes in parrent
	set_as_top_level(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	new_velocity += g * delta
	look_at(transform.origin + new_velocity.normalized(), Vector3.UP)
	transform.origin += new_velocity * delta
	#print(new_velocity)
	print(Engine.physics_ticks_per_second)

	
func activate_cam():
	bullet_cam.make_current()
	
func fire(muzzle_rotation):
	# apply initial firing impulse to the boolet
	#velocity.z = -Global.initial_velocity
	rotation = muzzle_rotation
	new_velocity = -transform.basis.z * Global.initial_velocity
	was_shot = true

func _on_body_entered(body):
	if body.is_in_group("Target"):
		queue_free()
	else:
		queue_free()
		
	print("bullet colided with:", body)
		
