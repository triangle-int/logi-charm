extends Node

signal loading_screen_has_full_coverage

@export var off_light_bulb: Texture2D
@export var on_light_bulb: Texture2D
@export var max_angle = 35.0
@export var frequency = 3.0

@onready var animation_player: AnimationPlayer = $CanvasLayer/AnimationPlayer
@onready var light_bulb: TextureRect = $CanvasLayer/VisibleArea/LightBulb
@onready var timer = $Timer


func _ready():
	light_bulb.texture = off_light_bulb

func _process(_delta):
	var time_passed = timer.wait_time - timer.time_left
	light_bulb.rotation = deg_to_rad(max_angle) * exp(-time_passed) \
		* cos(time_passed * TAU * frequency) 

func update_progress_bar(_value: float):
	pass

func start_outro_animation(_node: Node):
	light_bulb.texture = on_light_bulb
	animation_player.play("end_load")
	await animation_player.animation_finished
	queue_free()
