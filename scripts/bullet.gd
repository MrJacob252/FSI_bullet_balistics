extends RigidBody3D

## Nodes 
@onready var bullet_cam = $bullet_cam
@onready var bullet_player = $bullet_player

## vars
var was_shot: bool = false
var gravity: float = Global.gravity_cnst
var new_velocity: Vector3 = Vector3.ZERO
var w: Vector3 = Vector3.ZERO
var g: Vector3 = Vector3.DOWN * gravity

# signals
signal target_hit()

# Called when the node enters the scene tree for the first time.
func _ready():
	# When created as a child it instantly becomes it's own object so it can't 
	# be controlled by the changes in parrent
	set_as_top_level(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	w = Vector3.LEFT * Global.wind_speed
	new_velocity += g * delta
	new_velocity += w * delta
	look_at(transform.origin + new_velocity.normalized(), Vector3.UP)	
	transform.origin += (new_velocity * delta) 
	#print(new_velocity)
	#print(Engine.physics_ticks_per_second)


func _on_area_3d_body_entered(body):
	## if bullet collision arrea detecs it has entered body
	if body.is_in_group("Target"):
		# if target was hit -> emit signal, delete the bullet
		emit_signal("target_hit")
		queue_free()
	else:
		# else delete the bullet
		queue_free()
	
	#print("bullet colided with:", body)


func activate_cam():
	# Set the bullet camera active
	bullet_cam.make_current()


func fire(muzzle_rotation):
	# apply initial firing impulse to the bullet
	# Rotate the bullet so it's rotated the same way as the gun muzzle
	rotation = muzzle_rotation
	# Apply initial muzzle velocity
	new_velocity = -transform.basis.z * Global.initial_velocity
	was_shot = true
