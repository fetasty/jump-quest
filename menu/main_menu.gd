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


var mute: bool = false


func _ready() -> void:
	var version: Version = load(VERSION_PATH)
	version_info.text = version.version_str()
	update_game_state()
	update_game_data()
	GameState.game_state_changed.connect(on_game_state_changed)
	mute_icon.clicked.connect(on_mute_icon_clicked)


func update_game_state() -> void:
	match GameState.game_state:
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


func update_game_data() -> void:
	mute = SaveLoadManager.get_value("mute", false)
	if mute:
		mute_icon.icon_settings.icon_name = "volume-variant-off"
	else:
		mute_icon.icon_settings.icon_name = "volume-source"


func restart_game() -> void:
	Logger.info("Restart game!")


func on_game_state_changed(state_name: StringName, _value: Variant) -> void:
	match state_name:
		GameState.GAME_STATE:
			update_game_state()
		_:
			pass


func on_mute_icon_clicked() -> void:
	Logger.info("Mute icon clicked!")
	mute = not mute
	if mute:
		mute_icon.icon_settings.icon_name = "volume-variant-off"
	else:
		mute_icon.icon_settings.icon_name = "volume-source"


func _on_volume_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		Logger.info("Volume changed to: %s" % volume_slider.value)


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
