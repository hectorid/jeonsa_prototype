extends Node

var level : Node =  null

func spawn(obj : Node2D) -> void:
	level.add_child(obj)