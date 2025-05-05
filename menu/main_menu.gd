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
	GameState.game_state_changed.connect(on_game_state_changed)
	var version: Version = load(VERSION_PATH)
	version_info.text = version.version_str()
	update_game_state()


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


func on_game_state_changed(state_name: StringName, _value: Variant) -> void:
	match state_name:
		GameState.GAME_STATE:
			update_game_state()
		_:
			pass
