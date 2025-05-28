extends Node


@onready var game_layer: CanvasLayer = %GameLayer		# Layer for 2d game world
@onready var hud_layer: CanvasLayer = %HudLayer 		# layer for hud ui
@onready var menu_layer: CanvasLayer = %MenuLayer		# layer for menu (pause menu, main menu)


func _ready() -> void:
	# Set logger format
	Logger.time_format = "YYYY.MM.DD hh.mm.ss.SSS"
	Logger.info("Welcome to 'Jump-Quest', version: %s" % load("res://resource/version.tres").version_str)
	# Auto set window size
	if GameState.window_size.x == 0:
		GameState.window_size = DisplayServer.screen_get_size() * 0.5
	get_tree().root.size = GameState.window_size
	set_window_size_range()
	Logger.info("Auto set window size to %s" % GameState.window_size)
	# Initialize ui manager
	UiManager.hud_layer = hud_layer
	UiManager.menu_layer = menu_layer
	# Show main menu
	# UiManager.change_menu(UiManager.MAIN_MENU)


func _notification(what) -> void:
	match what:
		NOTIFICATION_WM_SIZE_CHANGED:
			on_window_size_changed()
		NOTIFICATION_WM_DPI_CHANGE:
			set_window_size_range()
		_:
			pass


func close_game_scene() -> void:
	for child in game_layer.get_children():
		child.queue_free()


func change_game_scene(scene_path: String) -> void:
	close_game_scene()
	var scene_src = load(scene_path) as PackedScene
	var scene = scene_src.instantiate()
	scene.name = "World"
	game_layer.add_child(scene)


func set_window_size_range() -> void:
	get_tree().root.min_size = Const.MIN_WINDOW_SIZE
	get_tree().root.max_size = DisplayServer.screen_get_size()


func on_window_size_changed() -> void:
	var window_size = get_tree().root.size
	GameState.window_size = window_size
