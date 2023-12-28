class_name Level

extends Node

signal components_attached

func _ready():
	for child in get_children():
		assert(child is BaseComponent)
		ComponentsSignals.attach_component(child)

	components_attached.emit()
