extends Node

@onready var player_1 = $"../Player1"
@onready var player_2 = $"../Player2"

var current_level_name: String = "level_1"
var level_name_tree: String = "Level1"
var level_path_tree: String = "../" + level_name_tree
var level_path_file: String = "res://Scenes/Levels/" + current_level_name + ".tscn"
var target_node: Node
@onready var remove_node: Node = $"../Level1"

var player1_spawn: Vector2
var player2_spawn: Vector2

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
	
	player1_spawn = player1_position
	player2_spawn = player2_position
	
	print("Going to level: ", next_level_id)
	# delete current level from scene tree
	remove_node.queue_free()
	
	# update paths and names
	update_vars(next_level_id)
	
	reset_players()
	
	# access desired level and load it
	
	var load_level = load(level_path_file)
	var level_instantiate = load_level.instantiate()
	call_deferred("add_child", level_instantiate)
	
	# connect the new level's exit area signal
	#target_node = get_node(level_path_tree)
	#target_node.get_child(0).connect("exit_level", next_level)
	level_instantiate.get_child(0).connect("exit_level", next_level)
	level_instantiate.get_child(1).connect("player1_reset", reset_player1)
	level_instantiate.get_child(1).connect("player2_reset", reset_player2)
	
	remove_node = level_instantiate
	
	# access desired player position for the new level
	# and set the player position to that
	#reset_players()
	

func reset_player1():
	player_1.global_position = player1_spawn

func reset_player2():
	player_2.global_position = player2_spawn

func reset_players():
	if(player_1.mask == true):
		player_1.global_position = player1_spawn
		player_2.global_position = player2_spawn
		player_1.ammo = 1
		player_2.ammo = 0
		player_2.update_pile(player_2)
	
	if(player_2.mask == true):
		player_1.global_position = player2_spawn
		player_2.global_position = player1_spawn
		player_2.ammo = 1
		player_1.ammo = 0
		player_1.update_pile(player_1)
	
