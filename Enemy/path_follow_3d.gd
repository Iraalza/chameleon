extends PathFollow3D

const SPEED := 5.0
const RETURN_DISTANCE_THRESHOLD := 1.0

enum State { PATROL, CHASE, RETURN }

var state := State.PATROL

@onready var enemy_body: CharacterBody3D = get_node("Enemy2")
var color_chameleon
var color_wall

# Keep both global and local starting data
var start_position: Vector3
var start_rotation: Vector3
var start_local_transform: Transform3D
var start_progress: float

func _ready() -> void:
	start_progress = progress
	start_position = enemy_body.global_position
	start_rotation = enemy_body.global_rotation
	start_local_transform = enemy_body.transform
	rotation_mode = PathFollow3D.ROTATION_Y

func _physics_process(delta: float) -> void:
	match state:
		State.PATROL:
			# Path drives motion + Y rotation
			rotation_mode = PathFollow3D.ROTATION_Y
			# Ensure the enemy is attached to the follower while patrolling
			if enemy_body.top_level:
				enemy_body.top_level = false
				enemy_body.transform = start_local_transform
			# Advance along path
			progress += delta * SPEED
			enemy_body.velocity = Vector3.ZERO
		
		State.CHASE:
			# Move in global space, detached from the path
			rotation_mode = PathFollow3D.ROTATION_NONE
			if not enemy_body.top_level:
				enemy_body.top_level = true
			var direction := Global.player.global_position - enemy_body.global_position
			direction.y = 0.0
			if direction.length() > 0.001:
				direction = direction.normalized()
				enemy_body.look_at(enemy_body.global_position + direction, Vector3.UP)
				enemy_body.velocity = direction * SPEED
			else:
				enemy_body.velocity = Vector3.ZERO
			enemy_body.move_and_slide()
		
		State.RETURN:
			# Return in global space, still detached
			rotation_mode = PathFollow3D.ROTATION_NONE
			if not enemy_body.top_level:
				enemy_body.top_level = true
			var return_direction := start_position - enemy_body.global_position
			return_direction.y = 0.0
			var dist := return_direction.length()
			if dist > 0.001:
				return_direction = return_direction.normalized()
				enemy_body.look_at(enemy_body.global_position + return_direction, Vector3.UP)
				enemy_body.velocity = return_direction * SPEED
				enemy_body.move_and_slide()
			else:
				enemy_body.velocity = Vector3.ZERO
				enemy_body.move_and_slide()
			# Snap and reattach when close enough
			if (start_position - enemy_body.global_position).length() <= RETURN_DISTANCE_THRESHOLD:
				# Stop the body
				enemy_body.velocity = Vector3.ZERO
				enemy_body.move_and_slide()
				# Reset the follower first
				progress = start_progress # usually 0.0
				rotation_mode = PathFollow3D.ROTATION_Y
				# Reattach and restore local offset
				enemy_body.top_level = false
				enemy_body.transform = start_local_transform
				# Optional: force exact facing if needed (path Y rotation will normally handle this)
				# enemy_body.global_rotation = start_rotation
				state = State.PATROL

func _on_enemy_2_find_chameleon(body: CharacterBody3D) -> void:
	state = State.CHASE
	color_chameleon = body.value_color

func _on_enemy_2_lost_chameleon() -> void:
	if state == State.CHASE:
		state = State.RETURN

func _on_enemy_2_find_wall(body: Variant) -> void:
	color_wall = body.value_color
	if color_chameleon == color_wall:
		if state == State.CHASE:
			state = State.RETURN
