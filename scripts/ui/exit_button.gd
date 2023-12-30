extends TextureButton


func _on_pressed():
	ComponentsSignals.stop_simulation()
	LoadManager.load_scene("res://scenes/level_selector.tscn")
