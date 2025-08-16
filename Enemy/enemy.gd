extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

func _physics_process(delta: float) -> void:
	
	move_rigt()
	move_and_slide()
	
	var angle = global_position.angle_to(Global.player.global_position)
	if rad_to_deg(angle) < 45:
		print(rad_to_deg(angle))
		$RayCast3D.look_at(Global.player.global_position)

func check_visible_player():
	var angle =  Global.player
	pass

func move_rigt():
	velocity = Vector3.RIGHT * SPEED

func move_left():
	velocity = Vector3.LEFT * SPEED

func move_down():
	velocity = Vector3.DOWN * SPEED

func move_up():
	velocity = Vector3.UP * SPEED
	
	
