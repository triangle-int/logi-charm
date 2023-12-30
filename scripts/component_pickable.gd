extends Node2D

@export var component: PackedScene

@onready var sprite_2d = $Sprite2D

var _is_dragged: bool
var _component_instance: BaseComponent

func _input(event):
	_handle_pickup(event)
	_handle_drag(event)

func _handle_pickup(event):
	if not event is InputEventMouseButton:
		return
	
	if event.button_index != MOUSE_BUTTON_LEFT:
		return
	
	if not sprite_2d.get_rect().has_point(to_local(event.position)):
		return
	
	_is_dragged = event.pressed
	
	if _is_dragged:
		_component_instance = component.instantiate() as BaseComponent

func _handle_drag(event):
	if not _is_dragged:
		return
