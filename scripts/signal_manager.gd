class_name SignalManager

extends Node

signal signal_out(index: int, high: bool, angle_start: float, angle_end: float)
signal simulation_started
signal simulation_stopped

const SIGNAL_SPEED = PI / 2

var components: Array[BaseComponent] = []
var timers: Array[Timer] = []
var is_simulating = false

func start_simulation():
	is_simulating = true
	simulation_started.emit()
	
func stop_simulation():
	for timer in timers:
		timer.stop()
	
	timers = []
	is_simulating = false
	simulation_stopped.emit()

func send_signal(index: int, high: bool, from: BaseComponent):
	if not is_simulating:
		return
	
	var next_angle = TAU
	var next: BaseComponent = null

	var components_at_rings = components.filter(
		func(c): return index >= c.attached_to and index <= c.attached_to + c.width - 1
	)
	
	for comp in components_at_rings:
		if comp.angle > from.angle and comp.angle < next_angle:
			next_angle = comp.angle
			next = comp
	
	if next == null:
		for comp in components_at_rings:
			if next == null or comp.angle < next.angle:
				next = comp
	
	var start_angle = from.angle
	var end_angle = next.angle + (TAU if next.angle < from.angle else 0.0)
	signal_out.emit(index, high, start_angle, end_angle)
	
	var timer = Timer.new()
	var move_angle = (end_angle - start_angle)
	if move_angle <= 0:
		move_angle += TAU
	timer.wait_time = move_angle / SIGNAL_SPEED
	timer.one_shot = true
	timer.timeout.connect(
		func ():
			timers.remove_at(timers.find(timer))
			next.receive_signal(index, high)
	)
	
	add_child(timer)
	timers.append(timer)
	timer.start()

func attach_component(component: BaseComponent):
	components.append(component)
	component._prepare_for_simulation()

func detach_all_components():
	components = []

func detach_component(component: BaseComponent):
	components.erase(component)

func can_attach_component(component: BaseComponent) -> bool:
	if component is InitComponent:
		return not components.any(func(comp): return comp is InitComponent)
	return true
