extends BaseComponent

func _on_receive(index: int, _high: bool):
	var result = false
	
	for ring in range(width):
		result = result or memory[ring]
	
	send_signal(index, result)
