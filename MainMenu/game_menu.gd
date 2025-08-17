extends CanvasLayer
signal hideMenu

func _on_exit_gm_pressed() -> void:
	get_tree().change_scene_to_file("res://MainMenu/main_menu.tscn")
	

func _on_continue_pressed() -> void:
	hideMenu.emit()
