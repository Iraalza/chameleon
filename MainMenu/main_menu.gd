extends CanvasLayer


func _on_exit_pressed() -> void:
	get_tree().quit()
	

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://TestRoom/test_room.tscn")

func _on_titles_pressed() -> void:
	pass # Replace with function body.
