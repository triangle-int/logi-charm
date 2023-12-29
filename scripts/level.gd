class_name Level

extends Node

signal game_over

@export var rings_config: RingsConfig;

var end_count = 0
var activated_count = 0

func start_level():
	update_components_positions()
	
	for child in get_children():
		assert(child is BaseComponent)
		ComponentsSignals.attach_component(child)
		
		if child is EndComponent:
			end_count += 1
			child.activated.connect(on_end_activated)

func on_end_activated():
	activated_count += 1
	
	if activated_count >= end_count:
		print("Game over!")
		game_over.emit()

func update_components_positions():
	for child: Node2D in get_children():
		var distances =\
			range(child.attached_to, child.attached_to + child.width)\
			.map(func(i): return rings_config.radiuses[i])
		
		var distance = distances.reduce(func(a, b): return a + b, 0) / len(distances)
		var angle = child.angle
		child.position = Vector2(cos(angle), -sin(angle)) * distance
		child.rotation = angle
