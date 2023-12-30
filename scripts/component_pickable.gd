extends Node2D

@export var component: PackedScene
@export var lerp_speed: float

@onready var sprite_2d = $Sprite2D
@onready var game: LevelLoader = $"/root/Game"

var _is_dragged: bool
var _component_instance: BaseComponent
var _target_position: Vector2

func _input(event):
	_handle_drag(event)
	_handle_drop(event)

func _on_input_event(_viewport, event, _shape_idx):
	_handle_pickup(event)

func _process(delta: float):
	_move_to_target(delta)

func _handle_pickup(event):
	if not event is InputEventMouseButton:
		return
	
	if event.button_index != MOUSE_BUTTON_LEFT or not event.pressed:
		return
	
	_is_dragged = true
	_component_instance = component.instantiate() as BaseComponent
	game.current_level.add_child(_component_instance)
	var component_position = game.current_level.to_local(event.global_position)
	_component_instance.set_anchor_position(component_position)
	_component_instance.set_body_position(component_position)
	_target_position = component_position

func _handle_drop(event):
	if not event is InputEventMouseButton:
		return
	
	if event.button_index != MOUSE_BUTTON_LEFT:
		return
	
	_is_dragged = false
	if _component_instance != null:
		_snap_to_rings()
		_component_instance = null

func _handle_drag(event):
	if not event is InputEventMouseMotion:
		return
	
	if not _is_dragged:
		return
	
	_target_position = game.current_level.to_local(event.global_position)

func _move_to_target(delta: float):
	if not _is_dragged or _component_instance == null:
		return
	
	var component_position: Vector2 = _component_instance.get_anchor_position()
	var lerped_position = component_position.lerp(_target_position, delta * lerp_speed)
	_component_instance.set_anchor_position(lerped_position)

func _snap_to_rings():
	ComponentsSignals.stop_simulation()
	
	var level: Level = game.current_level
	var component_position = _component_instance.get_anchor_position()
	var distance = component_position.length()
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
			# TODO: Implement component snapping with width=2
			pass
	
	_component_instance.attached_to = seleted_ring
	_component_instance.angle = atan2(-component_position.y, component_position.x)
	ComponentsSignals.attach_component(_component_instance)
	level.update_component_position(_component_instance)
