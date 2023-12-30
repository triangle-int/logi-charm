class_name InitComponent
extends BaseComponent

@export var start_index: int
@export var start_high: bool

@onready var sprite_2d = $RigidBody2D/Sprite2D

func _ready():
	sprite_2d.frame_coords.x = 0 if start_high else 1
	sprite_2d.frame_coords.y = 1
	

func _prepare_for_simulation():
	super()
	ComponentsSignals.simulation_started.connect(
		func(): send_signal(start_index, start_high)
	)
