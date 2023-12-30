class_name EndComponent

extends BaseComponent

signal activated
signal detached

@export var activation_seq: Array[bool]
@export var is_recording: bool

var is_activated = false
var is_detached = false
var last_index = 0
var history: Array[bool]

@onready var sprite_2d = $RigidBody2D/Sprite2D
@onready var pin_joint_2d = $PinJoint2D
@onready var goal_bar: GoalBar = $AnchorRemote/PanelContainer/GoalBar

func _ready():
	sprite_2d.frame_coords.x = 1

func _prepare_for_simulation():
	super()
	if is_recording:
		goal_bar.set_sequence(history)
	else:
		goal_bar.set_sequence(activation_seq)
	ComponentsSignals.simulation_started.connect(
		func():
			sprite_2d.frame_coords.x = 1
			is_activated = false
			is_detached = false
			last_index = 0
			history = []
			if is_recording:
				goal_bar.set_sequence(history)
			else:
				goal_bar.set_sequence(activation_seq)
	)

func _on_receive(index: int, high: bool):
	super(index, high)
	
	if is_recording:
		history.append(high)
		if len(history) > 15:
			history.pop_front()
		goal_bar.set_sequence(history)
		return
	
	if is_activated or is_detached:
		return
	
	if activation_seq[last_index] == high:
		goal_bar.remove_one()
		last_index += 1
	else:
		_detach()
	
	if last_index >= len(activation_seq):
		is_activated = true
		activated.emit()
		AudioManager.lamp_activated()
		sprite_2d.frame_coords.x = 0

func _detach():
	is_detached = true
	AudioManager.lose()
	sprite_2d.frame_coords.x = 2
	detached.emit()
