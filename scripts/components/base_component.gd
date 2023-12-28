class_name BaseComponent

extends Node

@export_range(0, TAU) var angle: float
@export var attached_to: int
@export var width: int

var memory: Dictionary = {}

func receive_signal(index: int, high: bool):
	print("%s received %s from ring %d" %[name, '1' if high else '0', index])
	print(Time.get_ticks_msec() / 1000)
	var local_index = index - attached_to
	memory[local_index] = high
	_on_receive(local_index, high)

func _on_receive(index: int, high: bool):
	send_signal(index, high)

func send_signal(index: int, high: bool):
	var global_index = index + attached_to
	ComponentsSignals.send_signal(global_index, high, self)
