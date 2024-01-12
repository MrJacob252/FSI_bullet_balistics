extends Node

var gravity_cnst: float = 9.8
var wind_speed: float = 0.10
#var initial_velocity: float = 100.5
var initial_velocity: float = 335.0

func _ready():
	Engine.physics_ticks_per_second = 240
	Engine.time_scale = 0.5
