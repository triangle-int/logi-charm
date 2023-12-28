class_name Level

extends Node

signal components_attached
signal game_over

var end_count = 0
var activated_count = 0

func _ready():
	for child in get_children():
		assert(child is BaseComponent)
		ComponentsSignals.attach_component(child)
		
		if child is EndComponent:
			end_count += 1
			child.activated.connect(on_end_activated)

	components_attached.emit()

func on_end_activated():
	activated_count += 1
	
	if activated_count >= end_count:
		print("Game over!")
		game_over.emit()
