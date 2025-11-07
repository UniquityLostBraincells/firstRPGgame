extends CharacterBody2D
const SPEED = 100
var current_direction = "none"
var enemy_in_range = false
var attack_cooldown = false
var health = 100
var is_alive = true
var attack_ip = false #check if attack is in progress for animations



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
	if health <= 0:
		health = 0 #make sure health isnt negative
		is_alive = false
	attack()



func play_anim(movement):
	var dir = current_direction
	var anim = $AnimatedSprite2D
	
# change animation for moving right
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0 :
			if attack_ip == false:
				anim.play("side_idle")

# change animation for moving left
	if dir == "left":
		anim.flip_h = true 
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0 :
			if attack_ip == false:
				anim.play("side_idle")
			
# change animation for moving up
	if dir == "up":
		if movement == 1:
			anim.play("back_walk")
		elif movement == 0 :
			if attack_ip == false:
				anim.play("back_idle")
			
# change animation for moving down
	if dir == "down":
		if movement == 1:
			anim.play("front_walk")
		elif movement == 0 :
			if attack_ip == false:
				anim.play("front_idle")


#detect hitbox entry for combat:

func _on_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_in_range = true

func _on_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_in_range = false
		
		
#so the enemy can detect if the area is of the player: 
func player():
	pass
	
func enemy_attack():
	if enemy_in_range and attack_cooldown == true:
		health = health - 10
		print(health)
		attack_cooldown = false
		#start the timer for attack cooldown
		attack_cooldown.start()

func _on_attack_cooldown_timeout():
	attack_cooldown = true

func attack():
	var dir = current_direction
	
	if Input.is_action_just_pressed("attack"):
		Global.player_current_attack = true
		attack_ip = true
		
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("side_attack")
			$deal_attack_timer.start()
	
		if dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("side_attack")
			$deal_attack_timer.start()
	
		if dir == "up":
			$AnimatedSprite2D.play("back_attack")
			$deal_attack_timer.start()
	
		if dir == "down":
			$AnimatedSprite2D.play("front_attack")
			$deal_attack_timer.start()

func _on_deal_attack_timeout() -> void:
		Global.player_current_attack = false
		attack_ip = false
