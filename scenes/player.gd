extends CharacterBody2D

@export var move_speed : float = 100
@export var run_speed : float = 150

func _process(_delta):
	#Get input direction
	var toggle_run = false
	var animated_sprite
	var input_direction = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("down","up")
		)
		
	if(input_direction.x > 0) :
		animated_sprite.flip_h = false
	else :
		animated_sprite.flip_h = true
		
	print(input_direction)
	 
	
	#Update velocity
	velocity = input_direction * move_speed
	if Input.is_key_pressed(KEY_SHIFT):
		velocity = input_direction * run_speed
		toggle_run = true
	if Input.is_action_just_released("shift"):
		velocity = input_direction * move_speed
		toggle_run = false
	#Move and slide function uses velocity of character body to move character on map
	move_and_slide()
	
