class_name SignalManager

extends Node

signal signal_out(index: int, high: bool, angle_start: float, angle_end: float)

const SLEEP_DURATION = 1.0

var components: Array[BaseComponent] = []

func send_signal(index: int, high: bool, from: BaseComponent):
	var next_angle = TAU
	var next: BaseComponent = components[0]

	var components_at_rings = components.filter(
		func(c): return index >= c.attached_to and index <= c.attached_to + c.width
	)
	
	for comp in components_at_rings:
		if comp.angle > from.angle and comp.angle < next_angle:
			next_angle = comp.angle
			next = comp
	
	if next == null:
		for comp in components_at_rings:
			if next == null or comp.angle < next.angle:
				next = comp
	
	signal_out.emit(index, high, from.angle, next.angle)
	
	get_tree().create_timer(SLEEP_DURATION).timeout.connect(
		next.receive_signal.bind(index, high)
	)

func attach_component(component: BaseComponent):
	components.append(component)