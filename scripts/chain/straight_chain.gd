class_name StraightChainGenerator

extends BaseChainGenerator

func generate(start: Vector2, end: Vector2):
	var offset = end - start
	var distance = offset.length()
	var nodes_count = floor(distance / node_length) as int
	var angle = atan2(offset.y, offset.x) + PI / 2
	count = 1
	
	for index in range(nodes_count):
		var position = lerp(start, end, (0.5 + index) / nodes_count)
		spawn_chain(position, angle)
