extends Button

@export var level_index: int

@onready var label = $Label

func _ready():
	disabled = level_index != 0 and not LevelProgressManager.is_level_beaten(level_index - 1)
	label.text = str(level_index).lpad(2, '0')

func _on_pressed():
	LoadManager.load_done.connect(_on_game_loaded)
	LoadManager.load_scene("res://scenes/game.tscn")

func _on_game_loaded(node: LevelLoader):
	LoadManager.load_done.disconnect(_on_game_loaded)
	node.ready.connect(node.load_level.bind(level_index))
