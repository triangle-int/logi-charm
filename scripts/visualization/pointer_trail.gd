extends Line2D

@export var max_length: int
@export var high_color: Color
@export var low_color: Color

var queue: Array[QueuePoint] = []
var is_high: bool

@onready var pointer = $"../Pointer"

func _ready():
	ComponentsSignals.signal_out.connect(_on_signal_out)

func _process(_delta):
	var pos = pointer.position
	var new_point = QueuePoint.new()
	new_point.point = pos
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

func _on_signal_out(_index: int, high: bool, _from_angle: float, _to_angle: float):
	is_high = high

class QueuePoint:
	var point: Vector2
	var high: bool
