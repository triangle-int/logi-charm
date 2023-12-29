extends ParallaxBackground

@export var angle: float
@export var speed: float

func _process(delta):
	var direction = Vector2(cos(angle), -sin(angle))
	scroll_offset += direction * (speed * delta)
