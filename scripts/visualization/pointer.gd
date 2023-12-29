class_name Pointer
extends Node2D

@export var high_sprite: Texture2D
@export var low_sprite: Texture2D

@onready var sprite_2d = $Sprite2D
var rings_config: RingsConfig

var radius: float = 0

func _ready():
	ComponentsSignals.signal_out.connect(_on_signal_out)

func _on_signal_out(index: int, high: bool, from_angle: float, to_angle: float):
	sprite_2d.texture = high_sprite if high else low_sprite
	to_angle = to_angle if to_angle > from_angle else to_angle + TAU
	radius = rings_config.radiuses[index]

	var tween = create_tween()	
	tween.tween_method(_move_pointer, from_angle, to_angle, ComponentsSignals.SLEEP_DURATION)

func _move_pointer(angle: float):
	position = Vector2(cos(angle), -sin(angle)) * radius
