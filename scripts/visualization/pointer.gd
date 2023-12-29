class_name Pointer
extends Node2D

var rings_config: RingsConfig
var radius: float = 0

@onready var pointer = $Pointer
@onready var high_particle_system = $Pointer/HighParticleSystem
@onready var low_particle_system = $Pointer/LowParticleSystem

func _ready():
	ComponentsSignals.signal_out.connect(_on_signal_out)

func _on_signal_out(index: int, high: bool, from_angle: float, to_angle: float):
	to_angle = to_angle if to_angle > from_angle else to_angle + TAU
	radius = rings_config.radiuses[index]
	
	high_particle_system.emitting = high
	low_particle_system.emitting = not high

	var tween = create_tween()	
	var time = (to_angle - from_angle) / ComponentsSignals.SIGNAL_SPEED
	tween.tween_method(_move_pointer, from_angle, to_angle, time)
	_move_pointer(from_angle)

func _move_pointer(angle: float):
	pointer.rotation = -angle
	pointer.position = Vector2(cos(angle), -sin(angle)) * radius
