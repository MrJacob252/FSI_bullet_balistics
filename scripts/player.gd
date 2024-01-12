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
@onready var audio_player = $"../audio_player"

#@onready var bullet = preload("res://scenes/bullet.tscn")
#@onready var bullet = preload("res://scenes/bullet2.tscn")
@onready var bullet = preload("res://scenes/bullet_backup.tscn")
@onready var shot_sound = preload("res://assets/sound/pew.wav")
@onready var hit_target = preload("res://assets/sound/beep.wav")
@onready var missed_target = preload("res://assets/sound/pop.wav")

## Consts
const MOUSE_SENS = 0.25
const X_LIMS = [deg_to_rad(-89), deg_to_rad(89)]

## Variables
var head: Node3D
var speed: float = 10.0
#var b: CharacterBody3D
var b: RigidBody3D
var velocity_label_format: String = "Velocity X: %.4f\nVelocity Y: %.4f\nVelocity Z: %.4f\n"
var hit_target_label_format: String = "Target hit: %s"
var wind_label_format: String = "Wind speed: %.2f m/s\nWind direction: %s"
var bullet_follow_format: String = "Follow bullet: %s"
var bullet_impulse_format: String = "Bullet muzzle speed: %.2f m/s"
var gravity_format: String = "Gravity strength: %.2f m/s^2"
var engine_speed_format: String = "Engine speed: %.0f%%"

var ctrl_mod: int = 1

var follow_cam: bool = true
## Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	#Engine.physics_ticks_per_second = 180
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	head = player_head
	init_hud()
	
func _input(event):
	# Mouse motion
	if event is InputEventMouseMotion:
		var rot_y: float = deg_to_rad(event.relative.x * MOUSE_SENS)
		var rot_x: float = deg_to_rad(event.relative.y * MOUSE_SENS)
		
		rotate_y(-rot_y)
		head.rotate_x(-rot_x)
		head.rotation.x = clamp(head.rotation.x, X_LIMS[0], X_LIMS[1])

func _process(delta):
	
	## Input processing
	if Input.is_action_just_pressed("ADS"):
		if cam_head.is_current():
			cam_ads.make_current()
		else:
			cam_head.make_current()
	
	if Input.is_action_just_pressed("fire"):
		if !is_instance_valid(b):	
			# Add instance of bullet b to a muzzle node and aim it at the collision point
			#var b = bullet.instantiate()
			update_target_label(false)
			b = bullet.instantiate()
			muzzle.add_child(b)
			if follow_cam:
				b.activate_cam()
			b.fire(player_head.global_rotation)
			b.connect("target_hit", update_target_label_signal)
			b.bullet_player.stream = shot_sound
			b.bullet_player.play()
			print("hit")
		else:
			print("bullet valid:", is_instance_valid(b))
	
	if Input.is_action_just_pressed("follow_cam_switch"):
		follow_cam_switch()
		update_follow_cam_label()
		
	if Input.is_action_just_pressed("wind_speed_left"):
		Global.wind_speed += 1 * ctrl_mod
	if Input.is_action_just_pressed("wind_speed_right"):
		Global.wind_speed -= 1 * ctrl_mod
	
	if Input.is_action_pressed("ctrl_mod"):
		ctrl_mod = 10
	else:
		ctrl_mod = 1
	
	if Input.is_action_just_pressed("gravity_down"):
		Global.gravity_cnst += 1 * ctrl_mod
	if Input.is_action_just_pressed("gravity_up"):
		Global.gravity_cnst -= 1 * ctrl_mod
	if Input.is_action_just_pressed("reset_gravity"):
		Global.gravity_cnst = 9.8
	
	if Input.is_action_just_pressed("bullet_speed_up"):
		Global.initial_velocity += 1 * ctrl_mod
	if Input.is_action_just_pressed("bullet_speed_down"):
		var tmp: float = Global.initial_velocity - 1 * ctrl_mod
		if 0 < tmp:
			Global.initial_velocity = tmp
			
	if Input.is_action_just_pressed("engine_up"):
		var tmp: float = Engine.time_scale + 0.1
		if tmp <= 1:
			Engine.time_scale = tmp
	if Input.is_action_just_pressed("engine_down"):
		var tmp: float = Engine.time_scale - 0.1
		if tmp >= 0.1:
			Engine.time_scale = tmp
	
	
	## Not inputs
	if is_instance_valid(b):
		update_velocity_label(b.new_velocity)
	
	update_wind_label()
	update_gravity_label()
	update_bullet_impulse_label()
	update_engine_speed_label()


func update_velocity_label(new_velocity):
	velocity_label.text = velocity_label_format % [new_velocity[0],new_velocity[1],new_velocity[2]]
	velocity_label.show()

func update_target_label(boolean):
	hit_target_label.text = hit_target_label_format % str(boolean)
	hit_target_label.show()

func update_target_label_signal():
	update_target_label(true)
	audio_player.stream = hit_target
	audio_player.play()
	
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
	
func follow_cam_switch():
	follow_cam = !follow_cam
	
func update_follow_cam_label():
	follow_cam_label.text = bullet_follow_format % str(follow_cam)
	follow_cam_label.show()

func update_gravity_label():
	gravity_label.text = gravity_format % Global.gravity_cnst
	gravity_label.show()

func update_bullet_impulse_label():
	bullet_impulse_label.text = bullet_impulse_format % Global.initial_velocity
	bullet_impulse_label.show()
	
func update_engine_speed_label():
	var engine_time = Engine.time_scale * 100
	engine_speed_label.text = engine_speed_format % engine_time
	engine_speed_label.show()
	
	
func init_hud():
	update_target_label(false)
	update_wind_label()
	update_velocity_label(Vector3(0, 0, 0))
	update_follow_cam_label()
	update_gravity_label()
	update_bullet_impulse_label()
	update_engine_speed_label()


