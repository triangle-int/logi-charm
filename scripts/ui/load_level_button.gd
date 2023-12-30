extends Node

@export var level_index: int

func _on_pressed():
	LoadManager.load_done.connect(_on_game_loaded)
	LoadManager.load_scene("res://scenes/game.tscn")

func _on_game_loaded(node: LevelLoader):
	LoadManager.load_done.disconnect(_on_game_loaded)
	node.ready.connect(node.load_level.bind(level_index))
