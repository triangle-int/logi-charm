class_name SignalManager

extends Node

@export var sleep_duration: float

class Component:
	var angle: float
	var comp: BaseComponent

var components: Array[Component] = []

func send_signal(index: int, high: bool, from: BaseComponent):
	var from_angle = components.filter(func(c): return c.comp == from)[0].angle
	var next: Component = null
	
	for comp in components:
		if next == null or comp.angle > from_angle and comp.angle < next.angle:
			next = comp
	
	get_tree().create_timer(sleep_duration).timeout.connect(
		next.comp.receive_signal.bind(index, high)
	)

func attach_component(component: Component):
	components.append(component)
