extends Node

signal loading_screen_has_full_coverage

@export var transition_duration = 0.3;

@onready var animation_player: AnimationPlayer = $CanvasLayer/AnimationPlayer
@onready var ring: Control = $CanvasLayer/VisibleArea/Ring
@onready var pointer: Control = $CanvasLayer/VisibleArea/Ring/Pointer

var _tween: Tween;
var _angle: float;

func _ready():
	_move_pointer(0.0);

func update_progress_bar(value: float):
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_method(_move_pointer, _angle, TAU * value, transition_duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func start_outro_animation():
	if _tween.is_running():
		await _tween.finished
	animation_player.play("end_load")
	await animation_player.animation_finished
	queue_free()

func _move_pointer(angle: float):
	var x = cos(angle) * 169.75
	var y = -sin(angle) * 169.75
	pointer.position = Vector2(x, y) + ring.size / 2.0 - pointer.size / 2.0
	_angle = angle
