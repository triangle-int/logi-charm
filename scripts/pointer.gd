class_name Pointer

extends Line2D

@export var max_length: int
@export var high_color: Color
@export var low_color: Color

var tween: Tween = null
var rings_config: RingsConfig
var queue: Array[QueuePoint] = []
var is_high: bool
var radius: float

func _ready():
	ComponentsSignals.simulation_started.connect(_on_started)
	ComponentsSignals.simulation_stopped.connect(_on_stopped)
	ComponentsSignals.signal_out.connect(_on_signal_out)

func _on_started():
	clear_points()
	queue = []

func _on_stopped():
	if tween:
		tween.kill()
	
	clear_points()
	queue = []

func _on_signal_out(index: int, high: bool, from_angle: float, to_angle: float):
	to_angle = to_angle if to_angle > from_angle else to_angle + TAU
	radius = rings_config.radiuses[index]
	is_high = high
	
	if tween != null:
		tween.stop()

	tween = create_tween()
	var time = (to_angle - from_angle) / ComponentsSignals.SIGNAL_SPEED
	tween.tween_method(_move_pointer, from_angle, to_angle, time)

func _move_pointer(angle: float):
	var new_point = QueuePoint.new()
	new_point.point = Vector2(cos(angle), -sin(angle)) * radius
	new_point.high = is_high
	queue.push_back(new_point)
	
	if len(queue) > max_length:
		queue.pop_front()

	clear_points()
	gradient = Gradient.new()
	gradient.colors = []
	gradient.offsets = []
	
	for index in range(len(queue)):
		var point = queue[index]
		var factor = (index as float) / len(queue)
		var color = high_color if point.high else low_color

		gradient.add_point(factor, color)
		add_point(point.point)

class QueuePoint:
	var point: Vector2
	var high: bool
