extends Node2D

const grid_size_options = [[8,8],[30,16]]
var chosen_grid_size = grid_size_options[1]
var initial_pos = Vector2(8,8)
var x_length
var y_length
var midpoint
var gamestart = false
var number_of_mines = 99
var unused_pos = []
#in form of node name: pos, type etc
# pos = [tile.name, 'unknown' (type), value, true (hidden)]
var tile_dict = {}
#PRELOADS
var tile_load = preload("res://tile.tscn")

func _ready() -> void:
	spawn_tiles()

# feed how big visible space is and where to initialize 1st cell
func spawn_tiles():
	
	var x_tiles = chosen_grid_size[0]
	var y_tiles = chosen_grid_size[1]
	#first need to find positions for each tile
	x_length = $sprites/hidden_tile.texture.get_width()
	y_length = $sprites/hidden_tile.texture.get_height()
	midpoint = Vector2(x_length/2,y_length/2)
	
	for x in x_tiles:
		for y in y_tiles:
			var tile = tile_load.instantiate()
			$tiles.add_child(tile)
			tile.position = Vector2(initial_pos.x + x_length * x, initial_pos.y + y_length * y )
			unused_pos.append(tile.position)
			tile_dict[tile.position] = [tile.name, 'unknown', 0, true]

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_click"):
		if get_global_mouse_position().x >= 0 and get_global_mouse_position().x <= chosen_grid_size[0] * x_length and get_global_mouse_position().y >= 0 and get_global_mouse_position().y <= chosen_grid_size[1] * y_length:
			var nearest_tile_pos = Vector2()
			nearest_tile_pos.x = floor(get_global_mouse_position().x/x_length) * x_length + initial_pos.x
			nearest_tile_pos.y = floor(get_global_mouse_position().y/y_length) * y_length + initial_pos.y

			if gamestart == false:
				initiate_board(nearest_tile_pos)
			
			else:
				pre_click_check(nearest_tile_pos)
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()

func initiate_board(click_pos):
	gamestart = true
	#turn first click safe
	var neighbors = create_neighbors(click_pos)
	neighbors.append(click_pos)
	for i in neighbors:
		unused_pos.erase(i)
	
	tile_dict[click_pos][1] = 'safe'

	#randomize mines around start
	var used_mine_positions = []
	
	for mine in number_of_mines:
		
		#converting row, column numbering to position
		var rand_tile_pos = unused_pos[randi_range(0,len(unused_pos) - 1)]
		unused_pos.erase(rand_tile_pos)
		update_dict(rand_tile_pos, 'mine', 0, true)
		used_mine_positions.append(rand_tile_pos)
		update_neighbors(rand_tile_pos,'mine')
	
	pre_click_check(click_pos)
	
func update_dict(pos,type,value,is_hidden):
	tile_dict[pos][1] = type
	tile_dict[pos][2] = value
	tile_dict[pos][3] = is_hidden

func update_neighbors(pos,type):	
	var neighbors = create_neighbors(pos)
	if type == 'mine':
		for i in neighbors:
			
			if 8 <= i.x and i.x <= chosen_grid_size[0] * x_length - midpoint.x and 8 <= i.y and i.y <= chosen_grid_size[1] * y_length - midpoint.y:
				if tile_dict[i][1] == 'unknown':
					tile_dict[i][1] = 'warning'
				tile_dict[i][2] += 1
	
	if type == 'safe':
		var safe_count = 0
		var theoretical_safe_count = 0
		for i in neighbors:
			if 8 <= i.x and i.x <= chosen_grid_size[0] * x_length - midpoint.x and 8 <= i.y and i.y <= chosen_grid_size[1] * y_length - midpoint.y:
				theoretical_safe_count += 1
				if tile_dict[i][1] != 'mine':
					safe_count +=1
		if safe_count == theoretical_safe_count:
			for i in neighbors:
				if 8 <= i.x and i.x <= chosen_grid_size[0] * x_length - midpoint.x and 8 <= i.y and i.y <= chosen_grid_size[1] * y_length - midpoint.y:
					
					if tile_dict[i][1] == 'unknown' or tile_dict[i][1] == 'warning':
						if tile_dict[i][3] == true:
							pre_click_check(i)
						
					
func pre_click_check(pos):
	var node_path = 'tiles/' + tile_dict[pos][0]
	if tile_dict[pos][3] == true:
		tile_dict[pos][3] = false
		match tile_dict[pos][1]:
			'warning':
				get_node(node_path).clicked(tile_dict[get_node(node_path).position])
			'mine':
				get_node(node_path).clicked(tile_dict[get_node(node_path).position])
			_:
				tile_dict[pos][1] = 'safe'
				get_node(node_path).clicked(tile_dict[get_node(node_path).position])
				update_neighbors(pos,'safe')

func create_neighbors(pos):
	var n = Vector2(pos.x, pos.y - y_length)
	var ne = Vector2(pos.x + x_length, pos.y - y_length)
	var e = Vector2(pos.x + x_length, pos.y)
	var se = Vector2(pos.x + x_length, pos.y + y_length)
	var s = Vector2(pos.x, pos.y + y_length)
	var sw = Vector2(pos.x - x_length, pos.y + y_length)
	var w = Vector2(pos.x - x_length, pos.y)
	var nw = Vector2(pos.x - x_length, pos.y - y_length)
	
	var neighbors = [n,ne,e,se,s,sw,w,nw]
	
	return neighbors






		
		
		
			
		
		
	
	
	
	
	
	
