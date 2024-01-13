extends Node

## Default settings variables
var def_muzzle_speed: float = 335.0
var def_gravity: float = 9.8
var def_wind: float = 1.0
var def_engine_speed: float = 0.5

## Global variables for setting up stuff
var gravity_cnst: float = def_gravity
var wind_speed: float = def_wind
var initial_velocity: float = def_muzzle_speed
var engine_scale: float = def_engine_speed

## First time loading the software
var initial_load: bool = true


func _ready():
	set_engine()


func set_engine():
	## Set engine variables
	Engine.physics_ticks_per_second = 480
	#Engine.time_scale = engine_scale


func set_engine_scale():
	Engine.time_scale = engine_scale
