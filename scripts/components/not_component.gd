extends BaseComponent

func _on_receive(index: int, high: bool):
	send_signal(index, not high)
