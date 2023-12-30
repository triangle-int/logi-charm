extends Button

@export var level_index: int

@onready var label = $Label

func _ready():
	disabled = level_index > 1 and not LevelProgressManager.is_level_beaten(level_index - 1)
	label.text = str(level_index).lpad(2, '0')

func _pressed():
	LevelManager.current_level = level_index
	LoadManager.load_scene("res://scenes/game.tscn")
