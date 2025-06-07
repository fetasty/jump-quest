extends Node


@onready var game_layer: CanvasLayer = %GameLayer		# Layer for 2d game world
@onready var hud_layer: CanvasLayer = %HudLayer 		# layer for hud ui
@onready var menu_layer: CanvasLayer = %MenuLayer		# layer for menu (pause menu, main menu)


func _ready() -> void:
	# Set logger format
	Logger.time_format = "YYYY.MM.DD hh.mm.ss.SSS"
	# TODO debug
	Logger.set_default_output_level(Logger.VERBOSE)
	var default_logger = Logger.get_module() as Logger.Module
	default_logger.set_output_level(Logger.DEBUG)

	Logger.debug("Debug logger mode")
	Logger.info("Welcome to 'Jump-Quest', version: %s" % load("res://resource/version.tres").version_str())
	# Auto set window size
	if GameState.window_size.x == 0:
		GameState.window_size = DisplayServer.screen_get_size() * 0.5
	get_tree().root.size = GameState.window_size
	set_window_size_range()
	Logger.info("Auto set window size to %s" % GameState.window_size)
	# Initialize scene manager
	SceneManager.hud_layer = hud_layer
	SceneManager.menu_layer = menu_layer
	SceneManager.game_layer = game_layer
	game_layer.scale = Vector2.ONE * GameState.game_scale
	# Show main menu
	SceneManager.change_menu(SceneManager.MAIN_MENU)


func _notification(what) -> void:
	match what:
		NOTIFICATION_WM_SIZE_CHANGED:
			on_window_size_changed()
		NOTIFICATION_WM_DPI_CHANGE:
			set_window_size_range()
		_:
			pass


func set_window_size_range() -> void:
	get_tree().root.min_size = Const.MIN_WINDOW_SIZE
	get_tree().root.max_size = DisplayServer.screen_get_size()


func on_window_size_changed() -> void:
	var window_size = get_tree().root.size
	GameState.window_size = window_size
