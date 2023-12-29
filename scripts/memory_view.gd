class_name MemoryView

extends Node

@export var high_color: Color
@export var low_color: Color
@export var led_groups: Array[Node]

var view_index: int

func set_angle(angle: float):
	view_index = floori(((angle + PI / 4) / TAU) * 4) % 4
	
	for group in led_groups:
		group.visible = false
	
	if view_index > len(led_groups):
		return
	
	led_groups[view_index].visible = true

func on_memory_set(index: int, high: bool):
	if view_index > len(led_groups):
		return
	
	var group = led_groups[view_index]
	
	if index > len(group.get_children()):
		return
	
	group.get_children()[index].self_modulate = high_color if high else low_color
