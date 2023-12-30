class_name EndComponent

extends BaseComponent

signal activated

@export var activation_seq: Array[bool]

var is_activated = false
var last_index = 0

@onready var level: Level = $".."
@onready var sprite_2d = $RigidBody2D/Sprite2D
@onready var pin_joint_2d = $PinJoint2D

func _ready():
	sprite_2d.frame = 1
	
	ComponentsSignals.simulation_started.connect(
		func():
			is_activated = false
			last_index = 0
	)

func _on_receive(index: int, high: bool):
	super(index, high)
	
	if is_activated:
		return
	
	if activation_seq[last_index] == high:
		last_index += 1
	else:
		last_index = 0
		_detach()
	
	if last_index >= len(activation_seq):
		is_activated = true
		activated.emit()
		sprite_2d.frame = 0

func _detach():
	# TODO: Create detaching logic
	pass
