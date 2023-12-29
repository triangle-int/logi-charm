class_name BaseComponent

extends Node

@export_range(0, TAU) var angle: float
@export var attached_to: int
@export var width: int
@export var memory_view: MemoryView

var memory: Dictionary = {}

func _ready():
	if memory_view != null:
		memory_view.set_angle(angle)
	
	ComponentsSignals.simulation_started.connect(
		func():
			for ring in range(width):
				memory[ring] = false
	)

func receive_signal(index: int, high: bool):
	print("%s received %s from ring %d" %[name, '1' if high else '0', index])
	var local_index = index - attached_to
	set_memory(local_index, high)
	_on_receive(local_index, high)

func _on_receive(index: int, high: bool):
	send_signal(index, high)

func send_signal(index: int, high: bool):
	var global_index = index + attached_to
	ComponentsSignals.send_signal(global_index, high, self)

func set_memory(index: int, high: bool):
	memory[index] = high
	
	if memory_view == null:
		return
	
	memory_view.on_memory_set(index, high)
