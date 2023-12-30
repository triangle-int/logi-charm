class_name LevelLoader
extends Node

@export var levels: Array[PackedScene]

var current_level: Level = null
var current_index

@onready var completed = $UI/Completed
@onready var failed = $UI/Failed

# For debugging
func _input(event: InputEvent):
	if event.is_action_pressed("ui_accept"):
		if ComponentsSignals.is_simulating:
			ComponentsSignals.stop_simulation()
		else:
			ComponentsSignals.start_simulation()

	if event.is_action_released("ui_focus_next"):
		load_level((current_index + 1) % len(levels))

func load_level(index: int):
	failed.visible = false
	completed.visible = false
	ComponentsSignals.stop_simulation()
	ComponentsSignals.detach_all_components()

	if current_level != null:
		current_level.queue_free()
		current_level.level_completed.disconnect(_on_level_completed)
		current_level.level_failed.disconnect(_on_level_failed)
	
	current_index = index
	current_level = levels[index].instantiate() as Level
	current_level.level_completed.connect(_on_level_completed)
	current_level.level_failed.connect(_on_level_failed)
	$Center.add_child(current_level)
	current_level.start_level()
	
	$Center/Rings/Chain1.visible = current_level.rings_config.radiuses.size() > 0
	$Center/Rings/Chain2.visible = current_level.rings_config.radiuses.size() > 1
	$Center/Rings/Chain3.visible = current_level.rings_config.radiuses.size() > 2
	$Center/Pointer.rings_config = current_level.rings_config

func _on_level_completed():
	completed.visible = true
	LevelProgressManager.save_level_beaten(current_index)

func _on_level_failed():
	failed.visible = true

func _on_back_to_menu_button_pressed():
	ComponentsSignals.stop_simulation()
	ComponentsSignals.detach_all_components()
	LoadManager.load_scene("res://scenes/level_selector.tscn")

func _on_next_level_button_pressed():
	load_level((current_index + 1) % len(levels))

func _on_continue_pressed():
	ComponentsSignals.stop_simulation()
	failed.visible = false
