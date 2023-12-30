extends Button


func _on_pressed():
	LoadManager.load_scene("res://scenes/level_selector.tscn")


func _on_button_down():
	AudioManager.button_press()
