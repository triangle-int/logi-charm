extends Button

func _pressed():
	LoadManager.load_scene("res://scenes/main_menu.tscn")

func _on_button_down():
	AudioManager.button_press()
