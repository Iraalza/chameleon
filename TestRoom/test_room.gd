extends Node3D
var is_game_menu_open = false

func _ready() -> void:
	$game_menu.hide()
	
func _process(delta: float) -> void:
	
	if Input.is_action_just_released("menu") && is_game_menu_open == false:
		$game_menu.show()
		is_game_menu_open = true
	elif Input.is_action_just_released("menu") && is_game_menu_open == true:
		$game_menu.hide()
		is_game_menu_open = false

func _on_game_menu_hide_menu() -> void:
	$game_menu.hide()
	is_game_menu_open = false
