extends TextureRect

@export var movement_sensetivity = 20.0;
var _initial_position: Vector2;


func _ready():
	_initial_position = global_position;


func _input(event):
	if event is InputEventMouseMotion:
		var offset = (event.position - (get_viewport().size / 2.0));
		global_position = _initial_position - (offset / Vector2(get_viewport().size)) * movement_sensetivity;
