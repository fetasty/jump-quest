extends Node

## Manage data saving and loading

const CONFIG_FILE_PATH = &"user://save.cfg"
const DEFAULT_SECTION = &"game"

var config_file: ConfigFile = ConfigFile.new()
var updated: bool = false


func _ready() -> void:
	load_data()
	create_autosave_timer()
	# connect signals, connect all data change
	AudioManager.data_changed.connect(set_value)


func create_autosave_timer() -> void:
	var timer: Timer = Timer.new()
	timer.wait_time = 5.0
	timer.one_shot = false
	timer.autostart = false
	timer.timeout.connect(save_data)
	add_child(timer)
	timer.start()


func load_data() -> void:
	if FileAccess.file_exists(CONFIG_FILE_PATH):
		var err := config_file.load(CONFIG_FILE_PATH)
		if err != OK:
			Logger.error("Failed to load game data from %s" % CONFIG_FILE_PATH, "main", err)
		else:
			Logger.info("Game data loaded from %s" % CONFIG_FILE_PATH)


func save_data() -> void:
	if updated:
		var err := config_file.save(CONFIG_FILE_PATH)
		if err != OK:
			Logger.error("Failed to save game data to %s" % CONFIG_FILE_PATH, "main", err)
		else:
			Logger.info("Game data saved to %s" % CONFIG_FILE_PATH)
		updated = false


func get_value(key: String, default: Variant = null) -> Variant:
	if config_file.has_section_key(DEFAULT_SECTION, key):
		return config_file.get_value(DEFAULT_SECTION, key)
	else:
		return default


func set_value(key: String, value: Variant) -> void:
	var old_value = get_value(key)
	if old_value != value:
		config_file.set_value(DEFAULT_SECTION, key, value)
		updated = true
