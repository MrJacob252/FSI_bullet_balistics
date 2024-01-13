extends Control

@onready var main = preload("res://scenes/main.tscn")
@onready var muzzle_speed_spin = $Options/muzzle_speed_spin
@onready var gravity_spin = $Options/gravity_spin
@onready var wind_spin = $Options/wind_spin
@onready var engine_speed_spin = $Options/engine_speed_spin
@onready var wind_direction_option = $Options/wind_direction_option

### set defaults
#var def_muzzle_speed: float = Global.initial_velocity
#var def_gravity: float = Global.gravity_cnst
#var def_wind: float = Global.wind_speed
#var def_engine_speed: float = Engine.time_scale

func _ready():
	set_dropdown()
	if Global.initial_load:
		set_default_boxes()
		Global.initial_load = false
	else:
		set_current_boxes()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_button_pressed():
	get_tree().change_scene_to_packed(main)


func _on_quit_button_pressed():
	get_tree().quit()


func _on_apply_button_pressed():
	apply_boxes()


func _on_defaults_button_pressed():
	set_default_boxes()
	wind_direction_option.select(0)
	apply_boxes()

func apply_boxes():
	Global.gravity_cnst = gravity_spin.value
	Global.engine_scale = engine_speed_spin.value * 0.01
	Engine.time_scale = Global.engine_scale
	Global.initial_velocity = muzzle_speed_spin.value
	
	if 1 == wind_direction_option.selected:
		Global.wind_speed = -wind_spin.value
	else:
		Global.wind_speed = wind_spin.value

func set_default_boxes():
	muzzle_speed_spin.value = Global.def_muzzle_speed
	gravity_spin.value = Global.def_gravity
	wind_spin.value = Global.def_wind
	engine_speed_spin.value = int(Global.def_engine_speed * 100)
	
func set_current_boxes():
	muzzle_speed_spin.value = Global.initial_velocity
	gravity_spin.value = Global.gravity_cnst
	wind_spin.value = Global.wind_speed
	engine_speed_spin.value = int(Global.engine_scale * 100)
	
	
func set_dropdown():
	wind_direction_option.add_item("Left", 0)
	wind_direction_option.add_item("Right", 1)
	wind_direction_option.select(0)
	
func debug_print():
	print(muzzle_speed_spin.value)
	print(gravity_spin.value)
	print(wind_spin.value)
	print(wind_direction_option.selected)
	print(engine_speed_spin.value)
