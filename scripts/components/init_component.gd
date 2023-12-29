extends BaseComponent

@export var start_index: int
@export var start_high: bool

func _ready():
	ComponentsSignals.simulation_started.connect(
		func(): send_signal(start_index, start_high)
	)
