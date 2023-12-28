extends BaseComponent

@export var start_index: int
@export var start_high: bool

func _ready():
	var component = SignalManager.Component.new()
	component.angle = 0
	component.comp = self
	signal_manager.attach_component(component)

	send_signal(start_index, start_high)
