extends Control

## Nodes
@onready var main = preload("res://scenes/main.tscn")
@onready var muzzle_speed_spin = $Options/muzzle_speed_spin
@onready var gravity_spin = $Options/gravity_spin
@onready var wind_spin = $Options/wind_spin
@onready var engine_speed_spin = $Options/engine_speed_spin
@onready var wind_direction_option = $Options/wind_direction_option


func _ready():
	set_dropdown()
	# Check if it is the first time loading the main menu or if user is 
	# returning from the main scene
	if Global.initial_load:
		set_default_boxes()
		Global.initial_load = false
	else:
		set_current_boxes()


func _on_start_button_pressed():
	# Switch scene to the main scene
	get_tree().change_scene_to_packed(main)


func _on_quit_button_pressed():
	# quit the software
	get_tree().quit()


func _on_apply_button_pressed():
	apply_boxes()


func _on_defaults_button_pressed():
	# Set defaults to the spinner boxes
	set_default_boxes()
	# Select default option for the dropdown
	wind_direction_option.select(0)
	# Apply the settings
	apply_boxes()


func apply_boxes():
	# Apply values from the spinners to Global variables
	Global.gravity_cnst = gravity_spin.value
	Global.engine_scale = engine_speed_spin.value * 0.01
	Engine.time_scale = Global.engine_scale
	Global.initial_velocity = muzzle_speed_spin.value
	
	# Apply wind speed value in the direction selected by the dropdown menu
	if 1 == wind_direction_option.selected:
		Global.wind_speed = -wind_spin.value
	else:
		Global.wind_speed = wind_spin.value


func set_default_boxes():
	# Set spinner boxes to default values
	muzzle_speed_spin.value = Global.def_muzzle_speed
	gravity_spin.value = Global.def_gravity
	wind_spin.value = Global.def_wind
	engine_speed_spin.value = int(Global.def_engine_speed * 100)


func set_current_boxes():
	# Set spinner boxes to the same values that are currently chosen
	muzzle_speed_spin.value = Global.initial_velocity
	gravity_spin.value = Global.gravity_cnst
	wind_spin.value = Global.wind_speed
	engine_speed_spin.value = int(Global.engine_scale * 100)


func set_dropdown():
	# Settup dropdown for use
	wind_direction_option.add_item("Left", 0)
	wind_direction_option.add_item("Right", 1)
	wind_direction_option.select(0)


func debug_print():
	# Debug function that prints values in all spinners and the dropdown
	print(muzzle_speed_spin.value)
	print(gravity_spin.value)
	print(wind_spin.value)
	print(wind_direction_option.selected)
	print(engine_speed_spin.value)
