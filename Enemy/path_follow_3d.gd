extends PathFollow3D

const SPEED = 5
var is_find_chameleon = false
var enemy_body: CharacterBody3D
var save_progress = 0.0
var direction_to_player
var count = 0
var save_point
var start_position
var start_rotation
const RETURN_DISTANCE_THRESHOLD = 1 

func _ready() -> void:
	enemy_body = get_node("Enemy2")
	start_position = enemy_body.global_position
	start_rotation = enemy_body.global_rotation

func _process(delta: float) -> void:
	if is_find_chameleon == false && count == 0:
		rotation_mode = PathFollow3D.ROTATION_Y
		progress += delta * SPEED
	elif is_find_chameleon == true:
		direction_to_player = Global.player.global_position - enemy_body.global_position
		direction_to_player = direction_to_player.normalized()
		direction_to_player.y = 0
		enemy_body.look_at(enemy_body.global_position + direction_to_player, Vector3.UP)
		enemy_body.velocity = direction_to_player * SPEED
		enemy_body.move_and_slide()
		count = 1
	elif is_find_chameleon == false && count == 1:
		var target_pos = global_position
		var return_direction = (start_position - enemy_body.global_position).normalized()
		direction_to_player.y = 0
		enemy_body.look_at(enemy_body.global_position + return_direction, Vector3.UP)
		enemy_body.velocity = return_direction * SPEED
		enemy_body.move_and_slide()
		var to_target = start_position - enemy_body.global_position
		var distanse = to_target.length()
		enemy_body.global_position.y = start_position.y
		if distanse < RETURN_DISTANCE_THRESHOLD:
			enemy_body.global_position = start_position
			enemy_body.global_rotation = start_rotation
		#Почему-то оно сюда не попадает, не понимаю почему, когда  я смотрю через дебаг он тут просто вертится туда сюда
		#А если и попадет сюда, то начинает как зря ходить
		if start_position == enemy_body.global_position:
			progress = 0.0
			count = 0

func _on_enemy_2_find_chameleon(body: CharacterBody3D) -> void:
	is_find_chameleon = true
	
func _on_enemy_2_lost_chameleon() -> void:
	is_find_chameleon = false
