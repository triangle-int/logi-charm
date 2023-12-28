class_name SignalManager

extends Node

var sleep_duration: float = 0.5
var components: Array[BaseComponent] = []

func send_signal(index: int, high: bool, from: BaseComponent):
	var next_angle = TAU
	var next: BaseComponent = null
	
	for comp in components:
		if comp.angle > from.angle and comp.angle < next_angle:
			next_angle = comp.angle
			next = comp
	
	if next == null:
		for comp in components:
			if next == null or comp.angle < next.angle:
				next = comp
	
	get_tree().create_timer(sleep_duration).timeout.connect(
		next.receive_signal.bind(index, high)
	)

func attach_component(component: BaseComponent):
	components.append(component)
