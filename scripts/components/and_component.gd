extends BaseComponent

func _ready():
	for ring in range(width):
		memory[ring] = false

func _on_receive(index: int, _high: bool):
	var result = true
	
	for ring in range(width):
		result = result and memory[ring]
	
	send_signal(index, result)
