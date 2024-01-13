extends CharacterBody3D

## Nodes
@onready var player_head = $head
@onready var cam_head = $head/cam_head
@onready var cam_bullet = $"../cam_bullet"
@onready var cam_ads = $head/gun/cam_ads
@onready var muzzle = $head/gun/muzzle
@onready var velocity_label = $head/cam_head/CanvasLayer/velocity_label
@onready var hit_target_label = $head/cam_head/CanvasLayer/hit_target_label
@onready var wind_label = $head/cam_head/CanvasLayer/wind_label
@onready var follow_cam_label = $head/cam_head/CanvasLayer/follow_cam_label
@onready var gravity_label = $head/cam_head/CanvasLayer/gravity_label
@onready var bullet_impulse_label = $head/cam_head/CanvasLayer/bullet_impulse_label
@onready var engine_speed_label = $head/cam_head/CanvasLayer/engine_speed_label
@onready var engine_physics_tic_label = $head/cam_head/CanvasLayer/engine_physics_tic_label
@onready var audio_player = $"../audio_player"
@onready var bullet_valid_label = $head/cam_head/CanvasLayer/bullet_valid_label

## Preload
@onready var bullet = preload("res://scenes/bullet_backup.tscn")
@onready var shot_sound = preload("res://assets/sound/pew.wav")
@onready var hit_target = preload("res://assets/sound/beep.wav")
@onready var missed_target = preload("res://assets/sound/pop.wav")

## Consts
const MOUSE_SENS = 0.25
# limits for up and down mouse look
const X_LIMS = [deg_to_rad(-89), deg_to_rad(89)]

## Variables
# current head for camera change
var head: Node3D
# bullet instance variable
var b: RigidBody3D
# ctrl modifier value
var ctrl_mod: int = 1
# follow camera on/off
var follow_cam: bool = true

## Hud labels text templates
var velocity_label_format: String = "Velocity X: %.4f\nVelocity Y: %.4f\nVelocity Z: %.4f\n"
var hit_target_label_format: String = "Target hit: %s"
var wind_label_format: String = "Wind speed: %.2f m/s\nWind direction: %s"
var bullet_follow_format: String = "Follow bullet: %s"
var bullet_impulse_format: String = "Bullet muzzle velocity: %.2f m/s"
var gravity_format: String = "Gravity strength: %.2f m/s^2"
var engine_speed_format: String = "Engine time scale: %.0f%%"
var engine_tic_format: String = "Engine physics tic rate: %.1f Hz"
var bullet_valid_format: String ="Bullet instance is valid: %s"

func _ready():
	# Set engine time scale
	Global.set_engine_scale()
	# Capture mouse for FPS controller mouse look
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	# Set player head as a current head
	head = player_head
	# initialise HUD
	init_hud()


func _input(event):
	# Mouse motion
	if event is InputEventMouseMotion:
		var rot_y: float = deg_to_rad(event.relative.x * MOUSE_SENS)
		var rot_x: float = deg_to_rad(event.relative.y * MOUSE_SENS)
		
		rotate_y(-rot_y)
		head.rotate_x(-rot_x)
		# Limit head rotation in vertical direction
		head.rotation.x = clamp(head.rotation.x, X_LIMS[0], X_LIMS[1])


func _process(delta):
	## Input processing
	# Change camera to the camera above the gun and vice-versa
	if Input.is_action_just_pressed("ADS"):
		if cam_head.is_current():
			cam_ads.make_current()
		else:
			cam_head.make_current()
	
	# Fire bullet
	if Input.is_action_just_pressed("fire"):
		# If bullet does not exist (limits number of bullets to one)
		if !is_instance_valid(b):
			# Set "target hit" to false
			update_target_label(false)
			# Create instance of a bullet 
			b = bullet.instantiate()
			# Place the bullet at the muzzle node
			muzzle.add_child(b)
			# Switch camera to camera on the bullet
			if follow_cam:
				b.activate_cam()
			# Connect signal that detects if target was hit
			b.connect("target_hit", update_target_label_signal)
			# fire the bullet
			b.fire(player_head.global_rotation)
			# Reset bullet's audio player volume
			b.bullet_player.volume_db = 0.0
			# Set firing sound
			b.bullet_player.stream = shot_sound
			# Play firing sound
			b.bullet_player.play()
			#print("hit")
		else:
			#print("bullet valid:", is_instance_valid(b))
			pass
	
	# Change ctrl modifier value to 10 if it's being held
	if Input.is_action_pressed("ctrl_mod"):
		ctrl_mod = 10
	else:
		ctrl_mod = 1
	
	# Switch camera follow state
	if Input.is_action_just_pressed("follow_cam_switch"):
		follow_cam_switch()
		update_follow_cam_label()
	
	# Change wind speed
	if Input.is_action_just_pressed("wind_speed_left"):
		Global.wind_speed += 1 * ctrl_mod
	if Input.is_action_just_pressed("wind_speed_right"):
		Global.wind_speed -= 1 * ctrl_mod
	
	# Change gravity value
	if Input.is_action_just_pressed("gravity_down"):
		Global.gravity_cnst += 1 * ctrl_mod
	if Input.is_action_just_pressed("gravity_up"):
		Global.gravity_cnst -= 1 * ctrl_mod
	# Reset gravity value
	if Input.is_action_just_pressed("reset_gravity"):
		Global.gravity_cnst = 9.8
	
	# Change bullet muzzle velocity
	if Input.is_action_just_pressed("bullet_speed_up"):
		Global.initial_velocity += 1 * ctrl_mod
	if Input.is_action_just_pressed("bullet_speed_down"):
		var tmp: float = Global.initial_velocity - 1 * ctrl_mod
		if 0 < tmp:
			Global.initial_velocity = tmp
	
	# Change engine time scale
	if Input.is_action_just_pressed("engine_up"):
		var tmp: float = Engine.time_scale + 0.1
		# Limits maximum to 1
		if tmp <= 1:
			Global.engine_scale = tmp
			Engine.time_scale = tmp
	if Input.is_action_just_pressed("engine_down"):
		var tmp: float = Engine.time_scale - 0.1
		# Limit minimum to 0.1
		if tmp >= 0.1:
			Global.engine_scale = tmp
			Engine.time_scale = tmp
	
	# Return to maun menu
	if Input.is_action_just_pressed("quit_to_menu"):
		# Change scene to main menu scene
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		# Change mouse mode to release mouse for menu use
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	
	## HUD elements updates
	if is_instance_valid(b):
		update_velocity_label(b.new_velocity)
	
	update_wind_label()
	update_gravity_label()
	update_bullet_impulse_label()
	update_engine_speed_label()
	update_physics_tic_label()
	update_bullet_valid_label()


# Switch camera follow mode
func follow_cam_switch():
	follow_cam = !follow_cam


# Function trigged by the bullet sending signal when it has hit a traget
func update_target_label_signal():
	update_target_label(true)
	# Load target hit sound to local player
	audio_player.stream = hit_target
	# Play target hit sound
	audio_player.play()


# Update muzzle velocity HUD label
func update_velocity_label(new_velocity):
	velocity_label.text = velocity_label_format % [new_velocity[0],new_velocity[1],new_velocity[2]]
	velocity_label.show()


# Update target hit label
func update_target_label(boolean):
	hit_target_label.text = hit_target_label_format % str(boolean)
	hit_target_label.show()


# Update wind speed HUD label
func update_wind_label():
	var wind_direction: String
	if Global.wind_speed < 0:
		wind_direction = "Right"
	elif Global.wind_speed > 0:
		wind_direction = "Left"
	else:
		wind_direction = "None"
	
	wind_label.text = wind_label_format % [Global.wind_speed, wind_direction]
	wind_label.show()


# Update camera follow mode HUD label
func update_follow_cam_label():
	follow_cam_label.text = bullet_follow_format % str(follow_cam)
	follow_cam_label.show()


# Update gravity value HUD label
func update_gravity_label():
	gravity_label.text = gravity_format % Global.gravity_cnst
	gravity_label.show()


# Update muzzle velocity HUD label
func update_bullet_impulse_label():
	bullet_impulse_label.text = bullet_impulse_format % Global.initial_velocity
	bullet_impulse_label.show()


# Update engine scale HUD label
func update_engine_speed_label():
	var engine_time = Engine.time_scale * 100
	engine_speed_label.text = engine_speed_format % engine_time
	engine_speed_label.show()


# Update engine physic tic HUD label
func update_physics_tic_label():
	engine_physics_tic_label.text = engine_tic_format % Engine.physics_ticks_per_second
	engine_physics_tic_label.show()


# Update if bullet validity HUD label
func update_bullet_valid_label():
	bullet_valid_label.text = bullet_valid_format % str(is_instance_valid(b))
	bullet_valid_label.show()


# Initialise all the HUD elements
func init_hud():
	update_target_label(false)
	update_wind_label()
	# Set all the bullet velocities to 0 on a startup
	update_velocity_label(Vector3(0, 0, 0))
	update_follow_cam_label()
	update_gravity_label()
	update_bullet_impulse_label()
	update_engine_speed_label()
	update_physics_tic_label()
	update_bullet_valid_label()
