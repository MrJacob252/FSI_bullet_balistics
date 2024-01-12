extends RigidBody3D

@onready var bullet_cam = $bullet_cam
@onready var bullet_player = $bullet_player

# consts


# vars
#var shoot: bool = false
var was_shot: bool = false

var gravity: float = Global.gravity_cnst
#var gravity: float = 0.98
#var gravity: Vector3 = Vector3(0, -9.8, 0)
var damping: float = 0.99
var custom_force: Vector3 = Vector3.ZERO
var new_velocity: Vector3 = Vector3.ZERO
var side_wind: Vector3 = Vector3.ZERO
var w: Vector3 = Vector3.ZERO
var g: Vector3 = Vector3.DOWN * gravity
var direction: Vector3

var local_transform: Transform3D = transform

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
	if body.is_in_group("Target"):
		emit_signal("target_hit")
		queue_free()
	else:
		queue_free()
		
	print("bullet colided with:", body)
		
func activate_cam():
	bullet_cam.make_current()
	
func fire(muzzle_rotation):
	# apply initial firing impulse to the boolet
	#velocity.z = -Global.initial_velocity
	rotation = muzzle_rotation
	new_velocity = -transform.basis.z * Global.initial_velocity
	was_shot = true


