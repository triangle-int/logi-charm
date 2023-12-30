class_name ComponentPickable
extends Node2D

enum COMPONENT_TYPE {
	AND_GATE,
	OR_GATE,
	SWAP_GATE,
	NOT_GATE,
	INIT_GATE,
	END_GATE,
}

@export var component: PackedScene
@export var component_type: COMPONENT_TYPE
@export var lerp_speed: float
@export var snap_threshold: float

@onready var sprite_2d = $Sprite2D
@onready var game: LevelLoader = $"/root/Game"

var _is_handling_events: bool
var _is_dragged: bool
var _component_instance: BaseComponent
var _target_position: Vector2

func _ready():
	_enable()
	game.level_loaded.connect(
		func():
			if component_type in game.current_level.avaliable_component:
				_enable()
			else:
				_disable()
	)

func _input(event):
	if not _is_handling_events:
		return
	
	_handle_drag(event)
	_handle_drop(event)

func _on_input_event(_viewport, event, _shape_idx):
	if not _is_handling_events:
		return
	
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
	var component_position = game.current_level.to_local(get_global_mouse_position())
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
	
	_target_position = game.current_level.to_local(get_global_mouse_position())

func _move_to_target(delta: float):
	if not _is_dragged or _component_instance == null:
		return
	
	var component_position: Vector2 = _component_instance.get_anchor_position()
	var lerped_position = component_position.lerp(_target_position, delta * lerp_speed)
	_component_instance.set_anchor_position(lerped_position)

func _snap_to_rings():
	var level: Level = game.current_level
	var radiuses = level.rings_config.radiuses
	match _component_instance.width:
		2:
			if len(radiuses) < 2:
				radiuses = []
			
			var new_radiuses = []
			for index in range(1, len(radiuses)):
				var diff = radiuses[index] - radiuses[index - 1]
				new_radiuses.append(radiuses[index - 1] + diff / 2)
			radiuses = new_radiuses
	
	var component_position = _component_instance.get_anchor_position()
	var distance = component_position.length()
	var seleted_ring = -1
	var selected_distance = 1e9
	for index in range(len(radiuses)):
		var new_distance = absf(radiuses[index] - distance)
		if new_distance < snap_threshold and \
			(seleted_ring == -1 or new_distance < selected_distance):
			seleted_ring = index
			selected_distance = new_distance
	
	if seleted_ring == -1:
		_component_instance.queue_free()
		return
	
	ComponentsSignals.stop_simulation()
	_component_instance.attached_to = seleted_ring
	_component_instance.angle = atan2(-component_position.y, component_position.x)
	if _component_instance.angle < 0:
		_component_instance.angle += 2 * PI
	ComponentsSignals.attach_component(_component_instance)
	level.update_component_position(_component_instance)

func _enable():
	visible = true
	_is_handling_events = true

func _disable():
	visible = false
	_is_handling_events = false
