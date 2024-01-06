extends CharacterBody3D

## Nodes
@onready var head = $head
@onready var cam_head = $head/cam_head
@onready var cam_bullet = $"../cam_bullet"
@onready var aimcast = $head/cam_head/aimcast
@onready var muzzle = $head/gun/muzzle

@onready var bullet = preload("res://scenes/bullet.tscn")

## Consts
const MOUSE_SENS = 0.25
const X_LIMS = [deg_to_rad(-89), deg_to_rad(89)]

## Variables
## Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event):
	# Mouse motion
	if event is InputEventMouseMotion:
		var rot_y: float = deg_to_rad(event.relative.x * MOUSE_SENS)
		var rot_x: float = deg_to_rad(event.relative.y * MOUSE_SENS)
		
		rotate_y(-rot_y)
		head.rotate_x(-rot_x)
		head.rotation.x = clamp(head.rotation.x, X_LIMS[0], X_LIMS[1])

func _process(delta):
	
	## Change camera test
	if Input.is_action_just_pressed("ADS"):
		if cam_head.is_current():
			cam_bullet.make_current()
		else:
			cam_head.make_current()
	
	if Input.is_action_just_pressed("fire"):
		if aimcast.is_colliding():
			# Add instance of bullet b to a muzzle node and aim it at the collision point
			var b = bullet.instantiate()
			muzzle.add_child(b)
			b.look_at(aimcast.get_collision_point(), Vector3.UP)
			b.activate_cam()
			b.shoot = true
			print("hit")
		else:
			print("missed")
