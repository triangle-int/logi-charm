class_name BaseComponent

extends Node

@onready var signal_manager: SignalManager = %SignalManager
var memory: Dictionary = {}

func receive_signal(index: int, high: bool):
	print("Received %s from %d" %['true' if high else 'false', index])
	memory[index] = high
	_on_receive(index, high)

func _on_receive(index: int, high: bool):
	send_signal(index, high)

func send_signal(index: int, high: bool):
	signal_manager.send_signal(index, high, self)
