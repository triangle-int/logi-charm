@tool

extends BaseChainGenerator

@export var radius: float

func _ready():
	var node_count = floor(radius * TAU / node_length) as int
	
	if node_count % 2 == 1:
		node_count += 1

	for index in range(node_count):
		var angle = (index as float) / node_count * TAU
		spawn_chain(
			Vector2(cos(angle), -sin(angle)) * radius,
			-angle
		)
