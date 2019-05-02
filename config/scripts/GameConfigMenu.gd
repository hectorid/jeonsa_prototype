extends Control

const BASE_CONFIG_ELEMENT = preload("res://config/scenes/BaseConfigElement.tscn")
const CONFIG_INT_ELEMENT = preload("res://config/scenes/ConfigIntElement.tscn")
const CONFIG_FLOAT_ELEMENT = preload("res://config/scenes/ConfigFloatElement.tscn")
const CONFIG_STRING_ELEMENT = preload("res://config/scenes/ConfigStringElement.tscn")

onready var ConfigList = find_node('ConfigList')

func _ready():
	var config := Config.get_all()

	for section in config.keys():
		ConfigList.add_child(ConfigSectonLabel.new(section))
		for key in config[section].keys():
			var value = config[section][key]
			add_config(section, key, value)
		ConfigList.add_child(HSeparator.new())

func _physics_process(delta):
	if Input.is_action_just_pressed("config_menu"):
		visible = !visible
		get_tree().paused = visible
		if visible:
			pass


func add_config(section : String, key : String, value) -> void:
	var new_element : BaseConfigElement = null

	match typeof(value):
		TYPE_INT:
			new_element = CONFIG_INT_ELEMENT.instance()
		TYPE_REAL:
			new_element = CONFIG_FLOAT_ELEMENT.instance()
		TYPE_STRING:
			new_element = CONFIG_STRING_ELEMENT.instance()
		_:
			new_element = BASE_CONFIG_ELEMENT.instance()


	if new_element != null:
		new_element.init(section, key, value)
		ConfigList.add_child(new_element)

func apply_config():
	for element in ConfigList.get_children():
		if element is BaseConfigElement:
			var section = element.section
			var key = element.key
			var value = element.value
			
			Config.set_var(section, key, value)

func reset_config():
	var config := Config.get_all()
	
	for element in ConfigList.get_children():
		if element is BaseConfigElement:
			var section = element.section
			var key = element.key
			
			element.value = config[section][key]

func save_config():
	apply_config()
	Config.save_config()