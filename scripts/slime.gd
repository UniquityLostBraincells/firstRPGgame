extends CharacterBody2D
var speed = 1
var player_chase = false
var player = null
var spawn_ani_finished = false
var health = 100
var player_in_range = false
var can_take_damage = true


func _ready() -> void:
	$AnimatedSprite2D.play("spawn")

func _on_idle_timeout_timeout() -> void:
	spawn_ani_finished = true

func _physics_process(delta):
	deal_damage()
	if spawn_ani_finished:
		if player_chase:
			position += ((player.position - position)/speed) * delta
			#since speed is being divided, greater speed variable = slower movement
			#play walk animation when moving
			$AnimatedSprite2D.play("walk")
		
		#flip sprite if moving left
			if (player.position.x - position.x) < 0:
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.flip_h = false
	
		else:
			$AnimatedSprite2D.play("idle")


func _on_detection_area_body_entered(body):
	player = body
	player_chase = true


func _on_detection_area_body_exited(_body):
	player = null
	player_chase = false
	
#so the player can detect it is an enemy:
func enemy():
	pass


func _on_hitbox_body_entered(body):
	if body.has_method("player"):
		player_in_range = false

func _on_hitbox_body_exited(body):
	if body.has_method("player"):
		player_in_range = false


func deal_damage():
	if player_in_range == true and Global.player_current_attack == true:
		if can_take_damage == true:
			$time.start()
			can_take_damage = false
			health = health - 20
			print(health)
			if health <= 20:
				self.queue_free()


func _on_hit_cooldown_timeout() -> void:
	can_take_damage = true
