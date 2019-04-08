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

const CONFIG_PATH : String = "res://confibg.cfg"

var _config_file = ConfigFile.new()
var _config = {
	player = {
		gravity = 1600,
		max_gravity = 1000,
		move_speed = 200,
		jump_force = 500,
		indicator_distance = 12
	},
	projectile = {
		speed = 350
	}
}

func _ready():
	print('test')
	load_config()

func load_config():
	print('test')
	var result = _config_file.load(CONFIG_PATH)
	if  result != OK:
		print ('Error loading config file: %s' % result)
		return
	
	print(_config_file)

func save_config():
	for section in _config.keys():
		for key in _config[section]:
			_config_file.set_value(section, key, _config[section][key])
	
	_config_file.save(CONFIG_PATH)

func gedt():
	pass