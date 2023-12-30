class_name BaseComponent

extends Node2D

@export_range(0, TAU) var angle: float
@export var attached_to: int
@export var width: int
@export var memory_view: MemoryView
@export var signal_angular_vel: float

@onready var rigid_body_2d: RigidBody2D = $RigidBody2D
@onready var anchor_remote: RemoteTransform2D = $AnchorRemote

var memory: Dictionary = {}

func _ready():
	if memory_view != null:
		memory_view.set_angle(angle)
	
	ComponentsSignals.simulation_started.connect(
		func():
			for ring in range(width):
				set_memory(ring, false)
	)

func receive_signal(index: int, high: bool):
	print("%s received %s from ring %d" %[name, '1' if high else '0', index])
	rigid_body_2d.angular_velocity = signal_angular_vel * (randi_range(0, 1) * 2 - 1)
	var local_index = index - attached_to
	set_memory(local_index, high)
	_on_receive(local_index, high)

func _on_receive(index: int, high: bool):
	send_signal(index, high)

func send_signal(index: int, high: bool):
	var global_index = index + attached_to
	ComponentsSignals.send_signal(global_index, high, self)

func set_memory(index: int, high: bool):
	memory[index] = high
	
	if memory_view == null:
		return
	
	memory_view.on_memory_set(index, high)

func set_anchor_position(new_position: Vector2):
	anchor_remote.position = new_position

func get_anchor_position() -> Vector2:
	return anchor_remote.position

func set_body_position(new_position: Vector2):
	rigid_body_2d.position = new_position

func set_body_rotation(new_angle: float):
	rigid_body_2d.rotation = new_angle

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		print("Removing component ", name)
		ComponentsSignals.stop_simulation()
		ComponentsSignals.detach_component(self)
		queue_free()
