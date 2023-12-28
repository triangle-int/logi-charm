class_name EndComponent

extends BaseComponent

signal activated

@export var activation_seq: Array[bool]

var is_activated = false
var last_index = 0

@onready var level: Level = $".."

func _on_receive(index: int, high: bool):
	super(index, high)
	
	if is_activated:
		return
	
	if activation_seq[last_index] == high:
		last_index += 1
	else:
		last_index = 0
	
	if last_index >= len(activation_seq):
		is_activated = true
		activated.emit()
