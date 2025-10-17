extends CharacterBody2D
var speed = 50
var player_chase = false
var player = null
var spawn_ani_finished = false

func _ready() -> void:
	$AnimatedSprite2D.play("spawn")
func _on_idle_timeout_timeout() -> void:
	spawn_ani_finished = true

func _physics_process(_delta):
	if spawn_ani_finished:
		if player_chase:
			position += (player.position - position)/speed
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


func _on_detection_area_body_entered(body: CharacterBody2D) -> void:
	player = body
	player_chase = true



func _on_detection_area_body_exited(_body: CharacterBody2D) -> void:
	player = null
	player_chase = false
