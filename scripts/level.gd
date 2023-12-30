@tool
class_name Level

extends Node

signal game_over

@export var rings_config: RingsConfig
@export_multiline var tooltip: String

var end_count = 0
var activated_count = 0

@onready var chains: StraightChainGenerator = $"../Chains"

func _process(_delta):
	if Engine.is_editor_hint():
		update_components_positions()

func start_level():
	update_components_positions(false)
	
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

func update_components_positions(smooth: bool = true):
	if chains != null:
		chains.clear()
	
	for child: Node2D in get_children():
		update_component_position(child, smooth)

func update_component_position(component: BaseComponent, smooth: bool = true):
	var angle = component.angle
	var unit_positon = Vector2(cos(angle), -sin(angle))
	
	var distances =\
		range(component.attached_to, component.attached_to + component.width)\
		.map(func(i): return rings_config.radiuses[i])

	if chains != null:
		chains.generate(
			unit_positon * distances.front(),
			unit_positon * distances.back(),
			component
		)
	
	var distance = distances.reduce(func(a, b): return a + b, 0) / len(distances)
	var new_position = unit_positon * distance
	if Engine.is_editor_hint():
		component.position = new_position
		component.rotation = angle
	else:
		component.position = Vector2(0.0, 0.0)
		component.rotation = 0.0
		component.set_anchor_position(new_position)
		component.set_body_rotation(angle + PI / 4.0)
		if not smooth:
			component.set_body_position(new_position)
