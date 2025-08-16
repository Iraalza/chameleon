class_name Player extends CharacterBody3D

@export var materials:Array[StandardMaterial3D]
@onready var ray_select_material:RayCast3D = $RaySelectMaterial

# Переменные передвижения
var can_move:bool=true
var speed: float = 5.0
var turn_speed: float = 2.0
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var m_sens = 0.002
var acceleration = 15

@onready var chameleon_mesh: MeshInstance3D = $Chameleon
var value_color:int=1 : set = set_material

func _ready() -> void:
	Global.player = self
	value_color = 2
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$Pivot/Camera3D.top_level = true
	$Pivot/Camera3D.rotation_degrees = Vector3(-90, 0, 0)
	
func _physics_process(delta):
	if can_move:
		input_interactive()

		var vy = velocity.y
		velocity = Vector3.ZERO
		
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("move_back"):
			velocity.z += 1
		if Input.is_action_pressed("move_forward"):
			velocity.z -=1
		
		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
			move_and_slide()
			$Pivot/Camera3D.global_position = $Pivot.global_position + Vector3(0, 15, 0)
		rotate_toward_mouse()

func input_interactive():
	if Input.is_action_just_pressed("interactive"):
		if ray_select_material.is_colliding():
			var collider=ray_select_material.get_collider()
			if collider as Wall:
				value_color = collider.value_color
		else:
			print("Не с чем взаимодействовать")

func set_material(new_value):
	chameleon_mesh.set_material_override(materials[new_value])
	value_color = new_value
	
func rotate_toward_mouse():
	
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 1000
	
	var from = $Pivot/Camera3D.project_ray_origin(mouse_pos)
	var to = from + $Pivot/Camera3D.project_ray_normal(mouse_pos) * ray_length
	
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = space.intersect_ray(query)
	
	if result:
		var target_pos = result.position
		target_pos.y = global_position.y  
		
		look_at(target_pos, Vector3.UP)
		
		rotation.x = 0
		rotation.z = 0
