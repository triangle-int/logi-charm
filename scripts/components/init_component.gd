extends BaseComponent

@export var start_index: int
@export var start_high: bool

func _prepare_for_simulation():
	super()
	ComponentsSignals.simulation_started.connect(
		func(): send_signal(start_index, start_high)
	)
