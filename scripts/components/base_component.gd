class_name BaseComponent

extends Node

@export_range(0, TAU) var angle: float

var memory: Dictionary = {}

func receive_signal(index: int, high: bool):
	print("%s received %s from ring %d" %[name, '1' if high else '0', index])
	memory[index] = high
	_on_receive(index, high)

func _on_receive(index: int, high: bool):
	send_signal(index, high)

func send_signal(index: int, high: bool):
	ComponentsSignals.send_signal(index, high, self)
