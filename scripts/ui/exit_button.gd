extends TextureButton


func _on_pressed():
	LoadManager.load_scene("res://scenes/level_selector.tscn")
