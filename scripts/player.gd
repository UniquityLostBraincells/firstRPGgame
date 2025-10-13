extends CharacterBody2D
const SPEED = 100
var current_direction = "none"

func _ready():
	$AnimatedSprite2D.play("front_idle" )


#create function to move player along axis
#it will also change current direction var so we can change animation later
func player_movement():
	#add rightwards movement
	if Input.is_action_pressed("move_right"):
		#play_anim is a function we will add later to change animation
		play_anim(1)
		current_direction = "right"
		velocity.x = SPEED 
		velocity.y = 0
	
	#add leftwards movement
	elif Input.is_action_pressed("move_left"):
		play_anim(1)
		current_direction = "left"
		velocity.x = -SPEED 
		velocity.y = 0
		
	#add downwards movement
	elif Input.is_action_pressed("move_down"):
		play_anim(1)
		current_direction = "down"
		velocity.x = 0
		velocity.y = SPEED 
		
	#add upwards movement
	elif Input.is_action_pressed("move_up"):
		play_anim(1)
		current_direction = "up"
		velocity.x = 0
		velocity.y = -SPEED 
		
	else:
		# pass 0 through play_anim since no movement and we want to play idle
		play_anim(0)
		velocity.x = 0
		velocity.y = 0
		
	move_and_slide()


#update player position every frame 
func _physics_process(_delta: float) -> void:
	player_movement()



func play_anim(movement):
	var dir = current_direction
	var anim = $AnimatedSprite2D
	
# change animation for moving right
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0 :
			anim.play("side_idle")

# change animation for moving left
	if dir == "left":
		anim.flip_h = true 
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0 :
			anim.play("side_idle")
			
# change animation for moving up
	if dir == "up":
		if movement == 1:
			anim.play("back_walk")
		elif movement == 0 :
			anim.play("back_idle")
			
# change animation for moving down
	if dir == "down":
		if movement == 1:
			anim.play("front_walk")
		elif movement == 0 :
			anim.play("front_idle")
