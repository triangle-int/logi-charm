extends Node2D

@export var component: PackedScene

@onready var sprite_2d = $Sprite2D
@onready var game: LevelLoader = $"/root/Game"

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
	
	if event.pressed and not sprite_2d.get_rect().has_point(to_local(event.position)):
		return
	
	_is_dragged = event.pressed
	
	if _is_dragged:
		_component_instance = component.instantiate() as BaseComponent
		game.current_level.add_child(_component_instance)
		_component_instance.global_position = event.position 
	elif _component_instance != null:
		_snap_to_rings()
		_component_instance = null

func _handle_drag(event):
	if not event is InputEventMouseMotion:
		return
	
	if not _is_dragged:
		return
	
	_component_instance.global_position = event.position

func _snap_to_rings():
	ComponentsSignals.stop_simulation()
	
	var level: Level = game.current_level
	var distance = _component_instance.position.length()
	var seleted_ring = -1
	match _component_instance.width:
		1:
			var radiuses = level.rings_config.radiuses
			var selected_distance = 1e9
			for index in range(len(radiuses)):
				var new_distance = absf(radiuses[index] - distance)
				if seleted_ring == -1 or new_distance < selected_distance:
					seleted_ring = index
					selected_distance = new_distance
		2:
			pass
	
	_component_instance.attached_to = seleted_ring
	_component_instance.angle = atan2(-_component_instance.position.y, _component_instance.position.x)
	ComponentsSignals.attach_component(_component_instance)
	level.update_components_positions()
