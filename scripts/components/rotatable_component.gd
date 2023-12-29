class_name RotatableComponent

extends BaseComponent

@onready var sprite_2d: Sprite2D = $RigidBody2D/Sprite2D

func _ready():
	super()

	var index = floor(((angle + PI / 4) / TAU) * 4) as int
	var frame = {0: 0, 1: 3, 2: 1, 3: 2}[index]
	sprite_2d.frame = frame
