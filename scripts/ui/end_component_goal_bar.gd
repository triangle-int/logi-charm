class_name GoalBar
extends HBoxContainer

@export var high_signal: Texture2D
@export var low_signal: Texture2D
@export var signal_scene: PackedScene

@onready var parent: Control = $".."

func _ready():
	for child in get_children():
		remove_child(child)
	
	parent.modulate.a = 0

func set_sequence(sequence: Array[bool]):
	for child in get_children():
		remove_child(child)
	
	for high in sequence:
		var signal_instance = signal_scene.instantiate()
		signal_instance.texture = high_signal if high else low_signal
		add_child(signal_instance)
	
	if get_child_count() > 0:
		parent.modulate.a = 1

func remove_one():
	remove_child(get_child(0))
	if get_child_count() <= 0:
		parent.modulate.a = 0
