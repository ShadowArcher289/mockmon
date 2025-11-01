extends CharacterBody2D

@export var move_speed : float = 100
@export var run_speed : float = 150
@onready var animated_sprite = $AnimatedSprite2D

func _ready() -> void:
	pass;

func _process(_delta):
	#Get input direction
	var toggle_run = false
	var input_direction = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
		)
	if input_direction.x == 0 && input_direction.y == 0 :
		animated_sprite.play("idle")
	if input_direction.x > 0 && input_direction.y == 0 :
		animated_sprite.flip_h = false
		animated_sprite.play("walk_horizontal")
	if input_direction.x < 0 && input_direction.y == 0 :
		animated_sprite.flip_h = true
		animated_sprite.play("walk_horizontal")
	if input_direction.x == 0 && input_direction.y > 0 :
		animated_sprite.play("walk_down")
	if input_direction.x == 0 && input_direction.y < 0 :
		animated_sprite.play("walk_up")
	if input_direction.x == 0 && input_direction.y < 0 && toggle_run == true :
		animated_sprite.play("run_up")
	if input_direction.x == 0 && input_direction.y > 0 && toggle_run == true :
		animated_sprite.play("run_down")
	if input_direction.x < 0 && input_direction.y == 0 && toggle_run == true :
		animated_sprite.flip_h = true
		animated_sprite.play("run_horizontal")
	if input_direction.x > 0 && input_direction.y == 0 && toggle_run == true :
		animated_sprite.flip_h = false
		animated_sprite.play("run_horizontal")
	
	 
	
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
	
