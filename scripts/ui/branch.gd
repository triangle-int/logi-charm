extends TextureRect

@export var normal_scale = 1.0;
@export var hovered_scale = 1.075;
@export var trans_duration = 0.2;

var _tween: Tween;


func _on_mouse_entered():
	if _tween:
		_tween.kill();
	_tween = create_tween();
	_tween.tween_property(self, "scale", Vector2.ONE * hovered_scale, trans_duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD);


func _on_mouse_exited():
	if _tween:
		_tween.kill();
	_tween = create_tween();
	_tween.tween_property(self, "scale", Vector2.ONE * normal_scale, trans_duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD);
