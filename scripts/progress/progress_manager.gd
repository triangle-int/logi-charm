class_name ProgressManager

extends Node

const SAVE_GAME_PATH = "user://savegame.tres"

var progress: Progress = Progress.new()

func _ready():
	if ResourceLoader.exists(SAVE_GAME_PATH):
		progress = load(SAVE_GAME_PATH)

func save_level_beaten(level_index: int):
	if level_index not in progress.levels_beaten:
		progress.levels_beaten.append(level_index)

	ResourceSaver.save(progress, SAVE_GAME_PATH)

func is_level_beaten(level_index: int):
	return level_index in progress.levels_beaten
