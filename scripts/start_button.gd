extends Button


func _on_pressed():
	LoadManager.currently_loaded = $"../../"
	LoadManager.load_scene("res://scenes/level_selector.tscn")
