extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const DETECTION_ANGLE = 45.0

var is_find_chameleon = false

var path_follow_node: PathFollow3D
var path_progress = 0.0
var return_target = Vector3.ZERO

signal find_chameleon(body)
signal lost_chameleon
	
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		is_find_chameleon = true
		find_chameleon.emit(body)

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is CharacterBody3D:
		lost_chameleon.emit()
