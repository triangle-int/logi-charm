@tool
class_name Level

extends Node

signal components_attached
signal game_over

@export var rings_radius: Array[float]

var end_count = 0
var activated_count = 0

func _ready():	
	update_components_positions()
	
	if Engine.is_editor_hint():
		return;
	
	for child in get_children():
		assert(child is BaseComponent)
		ComponentsSignals.attach_component(child)
		
		if child is EndComponent:
			end_count += 1
			child.activated.connect(on_end_activated)

	components_attached.emit()

func _process(delta):
	if Engine.is_editor_hint():
		update_components_positions()

func on_end_activated():
	activated_count += 1
	
	if activated_count >= end_count:
		print("Game over!")
		game_over.emit()

func update_components_positions():
	for child in get_children():
		assert(child is BaseComponent)
		var distance = rings_radius[child.attached_to]
		var angle = child.angle
		var x = cos(angle) * distance
		var y = -sin(angle) * distance
		child.position = Vector2(x, y)
