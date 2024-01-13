extends Node

var gravity_cnst: float = 9.8
var wind_speed: float = 1.0
#var initial_velocity: float = 100.5
var initial_velocity: float = 335.0
var engine_scale: float = 0.5

var def_muzzle_speed: float = initial_velocity
var def_gravity: float = gravity_cnst
var def_wind: float = wind_speed
var def_engine_speed: float = engine_scale

var initial_load: bool = true

func _ready():
	set_engine()

func set_engine():
	Engine.physics_ticks_per_second = 480
	#Engine.time_scale = engine_scale

func set_engine_scale():
	Engine.time_scale = engine_scale
