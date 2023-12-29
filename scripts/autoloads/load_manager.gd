extends Node

signal progress_changed(progress: float);
signal load_done;

var _load_screen_path = "res://scenes/loading_screen.tscn";
var _load_screen = load(_load_screen_path);
var _loaded_resource: PackedScene;
var _scene_path: String;
var _progress = [];

var use_sub_threads = true;


func load_scene(scene_path: String) -> void:
	_scene_path = scene_path;
	
	var new_loading_screen = _load_screen.instantiate();
	get_tree().get_root().add_child(new_loading_screen);
	
	progress_changed.connect(new_loading_screen.update_progress_bar);
	load_done.connect(new_loading_screen.start_outro_animation);
	
	await new_loading_screen.loading_screen_has_full_coverage;
	
	start_load();


func start_load() -> void:
	var state = ResourceLoader.load_threaded_request(_scene_path, "", use_sub_threads);
	if state == OK:
		set_process(true);


func _process(_delta):
	var load_status = ResourceLoader.load_threaded_get_status(_scene_path, _progress);
	match load_status:
		0, 2:
			set_process(false);
			return;
		1:
			progress_changed.emit(_progress[0]);
		3:
			_loaded_resource = ResourceLoader.load_threaded_get(_scene_path);
			progress_changed.emit(1.0);
			load_done.emit();
			get_tree().change_scene_to_packed(_loaded_resource);
			set_process(false);
