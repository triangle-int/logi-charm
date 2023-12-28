@tool
class_name Level

extends Node

signal components_attached
signal game_over

var end_count = 0
var activated_count = 0

@onready var rings = $"../Rings"

func _ready():	
	update_components_positions()
	
	if Engine.is_editor_hint():
		return
	
	for child in get_children():
		assert(child is BaseComponent)
		ComponentsSignals.attach_component(child)
		
		if child is EndComponent:
			end_count += 1
			child.activated.connect(on_end_activated)

	components_attached.emit()

func _process(_delta: float):
	if Engine.is_editor_hint():
		update_components_positions()

func on_end_activated():
	activated_count += 1
	
	if activated_count >= end_count:
		print("Game over!")
		game_over.emit()

func update_components_positions():
	if rings == null:
		return
	
	for child in get_children():
		var distance = rings.radiuses[child.attached_to]
		var angle = child.angle
		child.position = Vector2(cos(angle), -sin(angle)) * distance
