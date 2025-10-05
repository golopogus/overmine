extends Node2D

var danger = false
var state
var value

func change_state(new_state, warning_num):
	#$sprites/hidden.visible = false
	match new_state:
		'safe':
			state = new_state
			danger = false
			#$sprites/safe.visible = true
			
		'mine':
			state = new_state
			danger = true
			#$sprites/safe.visible = true
		'warning':
			state = new_state
			danger = false
			value = warning_num
		
func clicked():
	$sprites/hidden.visible = false
	
	match state:
		'safe':
			$sprites/safe.visible = true
	
		'mine': 
			$sprites/mine_clicked.visible = true
		
		'warning':
			var node_path = 'sprites/' + str(value)
			node_path.visible = true
					
			

	
		
