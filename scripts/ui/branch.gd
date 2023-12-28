@tool
extends TextureRect

@export_enum("CORNER_TOP_LEFT", "CORNER_TOP_RIGHT", "CORNER_BOTTOM_RIGHT", "CORNER_BOTTOM_LEFT") var corner: int;
@export var normal_scale = 1.0;
@export var hovered_scale = 1.075;
@export var trans_duration = 0.2;

var _tween: Tween;

@onready var _underline = $LevelBox/Underline;
@onready var _level_box = $LevelBox


func _ready():
	match corner:
		CORNER_TOP_LEFT:
			_level_box.position = $TopLeft.position;
		CORNER_TOP_RIGHT: 
			_level_box.position = $TopRight.position;
		CORNER_BOTTOM_RIGHT:
			_level_box.position = $BottomRight.position;
		CORNER_BOTTOM_LEFT:
			_level_box.position = $BottomLeft.position;


func _on_mouse_entered():
	if Engine.is_editor_hint():
		return;
	if _tween:
		_tween.kill();
	_tween = create_tween().set_parallel(true);
	_tween.tween_property(self, "scale", Vector2.ONE * hovered_scale, trans_duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD);
	_tween.tween_property(_underline, "value", 1.0, trans_duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD);


func _on_mouse_exited():
	if Engine.is_editor_hint():
		return;
	if _tween:
		_tween.kill();
	_tween = create_tween().set_parallel(true);
	_tween.tween_property(self, "scale", Vector2.ONE * normal_scale, trans_duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD);
	_tween.tween_property(_underline, "value", 0.0, trans_duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD);
