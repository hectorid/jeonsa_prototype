extends Node

const FLOOR_NORMAL := Vector2(0,-1)

# Player Variables
var PLAYER_GRAVITY := 1600
var PLAYER_MAX_GRAVITY := 1000
var PLAYER_MOVE_SPEED := 200
var PLAYER_JUMP_FORCE := 500
var PLAYER_INDICATOR_DISTANCE := 12

# Projectile Variables
var PROJECTILE_SPEED := 350

const CONFIG_PATH : String = "res://config/config.cfg"

var _config_file = ConfigFile.new()
var _config = {
	player = {
		gravity = 1600,
		max_gravity = 1000,
		move_speed = 200,
		jump_force = 500,
		indicator_distance = 12,
		energy_regen = 1.0,
		charge_rate = 1.5,
		max_charges = 5
	},
	projectile = {
		speed = 350,
		max_distance = 1000
	}
}

func _ready():
	load_config()

func load_config() -> int:
	var result : int = _config_file.load(CONFIG_PATH)
	if  result != OK:
		print ('Error loading config file: %s' % result)
		return result
	
	for section in _config.keys():
		for key in _config[section].keys():
			if _config_file.has_section_key(section, key):
				var value = _config_file.get_value(section, key)
	
				_config[section][key] = value
	
	return OK

func save_config():
	for section in _config.keys():
		for key in _config[section]:
			var value = _config[section][key]
			_config_file.set_value(section, key, value)

	_config_file.save(CONFIG_PATH)

func get_all() -> Dictionary:
	return _config

func get_section(section : String) -> Dictionary:
	return _config[section]

func get_var(section : String, key : String):
	return _config[section][key]

func set_var(section : String, key: String, value) -> void:
	_config[section][key] = value