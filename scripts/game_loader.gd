class_name LevelLoader
extends Node

signal level_loaded

@export var levels: Array[PackedScene]

var current_level: Level = null

@onready var completed = $UI/Completed
@onready var failed = $UI/Failed

func _ready():
	if LevelManager.current_level != -1:
		load_level(LevelManager.current_level)

func _input(event: InputEvent):
	if event.is_action_pressed("toggle_simulation"):
		print("Pressed")
		if ComponentsSignals.is_simulating:
			ComponentsSignals.stop_simulation()
		else:
			ComponentsSignals.start_simulation()

func load_level(index: int):
	failed.visible = false
	completed.visible = false
	ComponentsSignals.stop_simulation()
	ComponentsSignals.detach_all_components()

	if current_level != null:
		current_level.queue_free()
		current_level.level_completed.disconnect(_on_level_completed)
		current_level.level_failed.disconnect(_on_level_failed)
	
	LevelManager.current_level = index
	current_level = levels[index].instantiate() as Level
	current_level.level_completed.connect(_on_level_completed)
	current_level.level_failed.connect(_on_level_failed)
	$Center.add_child(current_level)
	current_level.start_level()
	
	$Center/Rings/Chain1.visible = current_level.rings_config.radiuses.size() > 0
	$Center/Rings/Chain2.visible = current_level.rings_config.radiuses.size() > 1
	$Center/Rings/Chain3.visible = current_level.rings_config.radiuses.size() > 2
	$Center/Pointer.rings_config = current_level.rings_config
	
	level_loaded.emit()

func _on_level_completed():
	completed.visible = true
	LevelProgressManager.save_level_beaten(LevelManager.current_level)

func _on_level_failed():
	failed.visible = true

func _on_back_to_menu_button_pressed():
	ComponentsSignals.stop_simulation()
	ComponentsSignals.detach_all_components()
	LoadManager.load_scene("res://scenes/level_selector.tscn")

func _on_next_level_button_pressed():
	load_level((LevelManager.current_level + 1) % len(levels))

func _on_continue_pressed():
	ComponentsSignals.stop_simulation()
	failed.visible = false
