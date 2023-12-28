extends BaseComponent

func _on_receive(index: int, high: bool):
	index = (index + 1) % width
	send_signal(index, high)
