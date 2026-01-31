extends Node

@onready var player_1 = $"../Player1"
@onready var player_2 = $"../Player2"

var current_level_name: String = "level_1"
var level_name_tree: String = "Level1"
var level_path_tree: String = "../" + level_name_tree
var level_path_file: String = "res://Scenes/Levels/" + current_level_name + ".tscn"
var target_node: Node

func _ready():
	update_vars(1)
	target_node = get_node(level_path_tree)
	
	if target_node:
		target_node.get_child(0).connect("exit_level", next_level)

func update_vars(level_id:int):
	current_level_name = "level_" + str(level_id)
	level_name_tree = "Level" + str(level_id)
	level_path_tree = "../" + level_name_tree
	level_path_file = "res://Scenes/Levels/" + current_level_name + ".tscn"

func next_level(next_level_id, player1_position, player2_position):
	
	# delete current level from scene tree
	var remove_node = get_node(level_path_tree)
	remove_node.queue_free()
	
	# update paths and names
	update_vars(next_level_id)
	
	# access desired level and load it
	
	var load_level = load(level_path_file)
	var level_instantiate = load_level.instantiate()
	call_deferred("add_child", level_instantiate)
	
	# connect the new level's exit area signal
	target_node = get_node(level_path_tree)
	#target_node.get_child(0).connect("exit_level", next_level)
	
	# access desired player position for the new level
	# and set the player position to that
	print(player1_position)
	print(player2_position)
	player_1.global_position = player1_position
	player_2.global_position = player2_position
	

func remove_level(level_id):
	pass
