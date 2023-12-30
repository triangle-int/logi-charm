extends TextureButton

func _on_toggled(toggled_on):
	if toggled_on:
		ComponentsSignals.start_simulation()
	else:
		ComponentsSignals.stop_simulation()
