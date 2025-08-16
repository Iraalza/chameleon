class_name Wall extends Node3D


@export var materials:Array[StandardMaterial3D]

@export var value_color:int=1
var rng = RandomNumberGenerator.new()

@onready var mesh:MeshInstance3D=$MeshInstance3D

func _ready() -> void:
	set_value()

func set_value():
	
	#Рандом, пока убрала, потому что еще не придумала как массивы цветов стен смэтчить с массивом цветов хамелеона
	#value_color = rng.randi_range(0, materials.size() - 1)
	#$MeshInstance3D.material_override = materials[value_color]
	
	#Не рандом
	$MeshInstance3D.material_override = materials[value_color]
	
	#var current_material = mesh.get_material_override()
	#match materials:
		#pass
	#for i in materials.size():
		#if current_material == materials[i-1]:
			#value_color = i
