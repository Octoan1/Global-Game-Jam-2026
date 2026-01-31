extends Node

var current_level = 1

@onready var exit_area = %ExitArea
const level_1 = preload("res://Scenes/Levels/level_1.tscn")

func _on_ready():
	
	if exit_area:
		exit_area.exit_level.connect(next_level)
		

func next_level():
	current_level += 1
	
