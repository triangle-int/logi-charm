extends TextureButton

@export var disabled_texture_normal: Texture2D
@export var disabled_texture_hover: Texture2D
@export var disabled_texture_pressed: Texture2D
@export var enabled_texture_normal: Texture2D
@export var enabled_texture_hover: Texture2D
@export var enabled_texture_pressed: Texture2D

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
	texture_normal = enabled_texture_normal if enabled else disabled_texture_normal
	texture_pressed = enabled_texture_pressed if enabled else disabled_texture_pressed
	texture_hover = enabled_texture_hover if enabled else disabled_texture_hover
