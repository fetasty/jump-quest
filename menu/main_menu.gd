extends Control


const VERSION_PATH = "res://resource/version.tres"


@onready var score: Label = %Score
@onready var mute_icon: FontIcon = %MuteIcon
@onready var volume_slider: HSlider = %VolumeSlider
@onready var count_down_button: CheckButton = %CountDownButton
@onready var start_button: Button = %StartButton
@onready var role_button: Button = %RoleButton
@onready var continue_button: Button = %ContinueButton
@onready var restart_button: Button = %RestartButton
@onready var guide_button: Button = %GuideButton
@onready var exit_button: Button = %ExitButton
@onready var version_info: Label = %VersionInfo


func _ready() -> void:
	# connect signals
	AudioManager.data_changed.connect(on_data_changed)
	GameState.data_changed.connect(on_data_changed)
	mute_icon.clicked.connect(on_mute_icon_clicked)
	# init version info
	var version: Version = load(VERSION_PATH)
	version_info.text = version.version_str()
	# load data
	load_data()


func load_data() -> void:
	update_game_state_ui(GameState.game_state)
	update_mute_ui(AudioManager.mute)
	update_volume_ui(AudioManager.volume)


func update_game_state_ui(state: int) -> void:
	match state:
		GameState.GAME_STATE_WELCOME, GameState.GAME_STATE_GAME_OVER:
			start_button.visible = true
			role_button.visible = true
			continue_button.visible = false
			restart_button.visible = false
		GameState.GAME_STATE_PAUSED:
			start_button.visible = false
			role_button.visible = false
			continue_button.visible = true
			restart_button.visible = true
		_:
			pass


func update_mute_ui(mute: bool) -> void:
	if mute:
		mute_icon.icon_settings.icon_name = "volume-variant-off"
	else:
		mute_icon.icon_settings.icon_name = "volume-source"


func update_volume_ui(volume: float) -> void:
	volume_slider.value = volume


func restart_game() -> void:
	Logger.info("Restart game!")


func on_data_changed(key: String, value: Variant):
	match key:
		AudioManager.KEY_MUTE:
			update_mute_ui(value)
		AudioManager.KEY_VOLUME:
			update_volume_ui(value)
		GameState.KEY_GAME_STATE:
			update_game_state_ui(value)
		_:
			pass


func on_mute_icon_clicked() -> void:
	Logger.info("Mute icon clicked!")
	AudioManager.mute = not AudioManager.mute


func _on_volume_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		Logger.info("Volume changed to: %s" % volume_slider.value)
		AudioManager.volume = volume_slider.value


func _on_count_down_button_toggled(toggled_on: bool) -> void:
	pass # Replace with function body.


func _on_start_button_pressed() -> void:
	restart_game()


func _on_role_button_pressed() -> void:
	pass # Replace with function body.


func _on_continue_button_pressed() -> void:
	pass # Replace with function body.


func _on_restart_button_pressed() -> void:
	restart_game()


func _on_guide_button_pressed() -> void:
	pass # Replace with function body.


func _on_exit_button_pressed() -> void:
	get_tree().quit()
