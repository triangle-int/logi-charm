extends BaseComponent

@export var start_index: int
@export var start_high: bool

@onready var level: Level = $".."

func _ready():
	await level.components_attached
	send_signal(start_index, start_high)
