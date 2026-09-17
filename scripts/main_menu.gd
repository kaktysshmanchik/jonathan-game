extends Control


func _on_start_button_pressed() -> void:
	GameState.reset_game()
	get_tree().change_scene_to_file("res://scenes/playroom.tscn")
