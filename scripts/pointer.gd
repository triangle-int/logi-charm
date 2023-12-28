extends Node2D

@export var high_sprite: Texture2D
@export var low_sprite: Texture2D

@onready var sprite_2d = $Sprite2D

var _radius = 0.0

func _ready():
	ComponentsSignals.signal_out.connect(_on_signal_out)

func _on_signal_out(index: int, high: bool, from_angle: float, to_angle: float):
	sprite_2d.texture = high_sprite if high else low_sprite
	
	var ring = get_tree().get_nodes_in_group("rings").filter(func (r): return r.index == index)[0]
	_radius = ring.radius
	
	var tween = create_tween()
	tween.tween_method(_move_pointer, from_angle, to_angle, ComponentsSignals.SLEEP_DURATION)

func _move_pointer(angle: float):
	var x = cos(angle) * _radius
	var y = -sin(angle) * _radius
	position = Vector2(x, y)
