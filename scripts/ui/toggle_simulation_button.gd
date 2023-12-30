extends TextureButton

@export var disabled_texture: Texture2D
@export var enabled_texture: Texture2D

var enabled: bool

func _ready():
	enabled = false
	update_texture()

	ComponentsSignals.simulation_started.connect(
		func():
			enabled = true
			update_texture()
	)
	
	ComponentsSignals.simulation_stopped.connect(
		func():
			enabled = false
			update_texture()
	)
	
func _pressed():
	enabled = not enabled
	
	if enabled:
		ComponentsSignals.start_simulation()
	else:
		ComponentsSignals.stop_simulation()

func update_texture():
	var texture = enabled_texture if enabled else disabled_texture
	texture_normal = texture
	texture_pressed = texture
	texture_hover = texture
	texture_disabled = texture
