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
			add_config(key, value)
		ConfigList.add_child(HSeparator.new())


func add_config(name : String, value) -> void:
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
		new_element.init(name, value)
		ConfigList.add_child(new_element)