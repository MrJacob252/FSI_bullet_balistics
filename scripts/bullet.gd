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
# Radius of the bullet shape [m]
var r: float = 0.06
# Height of the bulet shape minus the radii [m]
var h: float = 0.18 - (2 * r)
# density od a lead [kg/m3]
var rho_bullet:float = 11340.0
# density of air [kg/m3]
var rho_air: float = 1.293
# Drag coeficient
var drag: float = 0.47
# Area of the bullets' side crossection [m2]
var area: float = (PI * (r**2.0)) + (2 * r * h)
# Volume of the bullet shape [m3]
var volume: float = (0.75 * PI * (r**3.0)) + (PI * h * (r**2.0))
# mass of the bullet [kg]
var m: float = rho_bullet * volume
# wind preassure
var preassure: float
# Wind force
var force: float
# Wind acceleration
var a: float
# Final wind velocity
var v_f: float


# signals
signal target_hit()

# Called when the node enters the scene tree for the first time.
func _ready():
	# When created as a child it instantly becomes it's own object so it can't 
	# be controlled by the changes in parrent
	set_as_top_level(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	new_velocity += g * delta
	
	## Calculation of the velocity change due to wind
	# wind preassure
	preassure = 0.5 * rho_air * (Global.wind_speed**2)
	# Wind force
	force = area * preassure * drag
	# Wind acceleration
	a = force / m
	# Final wind speed
	v_f = a * delta
	
	if Global.wind_speed < 0:
		v_f *= -1.0
	
	w = Vector3.LEFT * v_f
	#w = Vector3.LEFT * Global.wind_speed
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
