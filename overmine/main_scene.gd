extends Node2D

const grid_size_options = [[8,8]]
var chosen_grid_size = grid_size_options[0]
var initial_pos = Vector2(8,8)
var x_length
var y_length
var midpoint
var gamestart = false
var number_of_mines
#in form of node name: pos, type etc
#name = [pos,type,hidden]
var tile_dict = {}
#PRELOADS
var tile_load = preload("res://tile.tscn")

func _ready() -> void:
	spawn_tiles(initial_pos)

# feed how big visible space is and where to initialize 1st cell
func spawn_tiles(starting_pos):
	
	var x_tiles = chosen_grid_size[0]
	var y_tiles = chosen_grid_size[1]
	#first need to find positions for each tile
	x_length = $sprites/hidden_tile.texture.get_width()
	y_length = $sprites/hidden_tile.texture.get_height()
	midpoint = Vector2(x_length/2,y_length/2)
	
	var current_pos = starting_pos
	
	for x in x_tiles:
		for y in y_tiles:
			var tile = tile_load.instantiate()
			$tiles.add_child(tile)
			tile.position = Vector2(current_pos.x + x_length * x, current_pos.y + y_length * y )
			tile_dict[tile.position] = [tile.name, 'unknown', true]

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_click"):
		
		var nearest_tile_pos = Vector2()
		nearest_tile_pos.x = floor(get_global_mouse_position().x/x_length) * x_length + initial_pos.x
		nearest_tile_pos.y = floor(get_global_mouse_position().y/y_length) * y_length + initial_pos.y
		#var sprite_path = 'tiles/' + tile_dict[nearest_tile_pos][0] + '/sprites/hidden'
		
		#get_node(sprite_path).visible = false
		if gamestart == false:
			initiate_mines(nearest_tile_pos)

func initiate_mines(click_pos):
	var starting_tile_path = 'tiles/' + tile_dict[click_pos][0]
	
	#turn first click safe
	
	get_node(starting_tile_path).change_state('safe')
	get_node(starting_tile_path).clicked()
	
	
		
		
		
		
			
		
		
	
	
	
	
	
	
