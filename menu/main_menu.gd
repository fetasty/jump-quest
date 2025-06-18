extends Control


const VERSION_PATH = "res://resource/version.tres"

@onready var score: Label = %Score
@onready var mute_icon: FontIcon = %MuteIcon
@onready var volume_slider: HSlider = %VolumeSlider
@onready var count_down_button: CheckButton = %CountDownButton
@onready var start_button: Button = %StartButton
@onready var role_button: Button = %RoleButton
@onready var continue_button: Button = %ContinueButton
@onready var stop_button: Button = %StopButton
@onready var guide_button: Button = %GuideButton
@onready var exit_button: Button = %ExitButton
@onready var version_info: Label = %VersionInfo
@onready var guide: Control = %Guide
@onready var role_select: Control = %RoleSelect
@onready var difficulty_container: HBoxContainer = %DifficultyContainer
@onready var difficulty_buttons: Array[Button] = [%Easy, %Normal, %Hard]
@onready var count_down: Control = %CountDown
@onready var menu_container = %MenuContainer


func _ready() -> void:
	# connect signals
	GameEvent.data_changed.connect(on_data_changed)
	AudioManager.background_finished.connect(on_background_finished)
	mute_icon.clicked.connect(on_mute_icon_clicked)
	for i in range(0, difficulty_buttons.size()):
		var btn = difficulty_buttons[i]
		btn.pressed.connect(_on_difficulty_button_pressed.bind(i))
	# init version info
	var version: Version = load(VERSION_PATH)
	version_info.text = version.version_str()
	# load data
	load_data()


func _gui_input(event: InputEvent) -> void:
	# FIXME: not working!
	if event.is_action_pressed("esc") and GameState.game_state == GameState.GAME_STATE_PAUSED:
		GameState.game_state = GameState.GAME_STATE_PLAYING
		accept_event()


func load_data() -> void:
	count_down_button.set_pressed_no_signal(GameState.count_down)
	update_game_state_ui(GameState.game_state)
	update_mute_ui(AudioManager.mute)
	update_volume_ui(AudioManager.volume)
	update_difficulty_ui(GameState.difficulty)


func update_game_state_ui(state: int) -> void:
	match state:
		GameState.GAME_STATE_WELCOME, GameState.GAME_STATE_GAME_OVER:
			visible = true
			menu_container.visible = true
			start_button.visible = true
			role_button.visible = true
			continue_button.visible = false
			stop_button.visible = false
			difficulty_container.visible = true
			# play background audio
			AudioManager.play_background(Const.MAIN_MENU_BACK_AUDIO)
		GameState.GAME_STATE_PAUSED:
			visible = true
			menu_container.visible = true
			start_button.visible = false
			role_button.visible = false
			continue_button.visible = true
			stop_button.visible = true
			difficulty_container.visible = false
		GameState.GAME_STATE_COUNTING_DOWN:
			visible = true
			menu_container.visible = false
			AudioManager.stop_background()
		GameState.GAME_STATE_PLAYING:
			visible = false
			AudioManager.play_background(Const.GAME_BACK_AUDIO)
		_:
			pass


func update_mute_ui(mute: bool) -> void:
	if mute:
		mute_icon.icon_settings.icon_name = "volume-variant-off"
	else:
		mute_icon.icon_settings.icon_name = "volume-source"


func update_volume_ui(volume: float) -> void:
	volume_slider.value = volume


func update_difficulty_ui(value: int) -> void:
	difficulty_buttons[value].set_pressed_no_signal(true)


func restart_game() -> void:
	Logger.info("Restart game!")
	GameState.reset_runtime_state()
	if GameState.count_down:
		GameState.game_state = GameState.GAME_STATE_COUNTING_DOWN
		count_down.start()
		await count_down.finished
	GameState.game_state = GameState.GAME_STATE_PLAYING
	SceneManager.show_hud()
	SceneManager.change_game_scene(SceneManager.GAME_SCENE)


func on_data_changed(key: String, value: Variant):
	match key:
		Const.MUTE:
			update_mute_ui(value)
		Const.VOLUME:
			update_volume_ui(value)
		Const.GAME_STATE:
			update_game_state_ui(value)
		Const.SCORE:
			score.text = str(value)
		_:
			pass


func on_background_finished() -> void:
	await get_tree().create_timer(randf_range(5.0, 15.0)).timeout
	match GameState.game_state:
		GameState.GAME_STATE_WELCOME, GameState.GAME_STATE_GAME_OVER:
			AudioManager.play_background(Const.MAIN_MENU_BACK_AUDIO)
		GameState.GAME_STATE_PLAYING, GameState.GAME_STATE_PAUSED:
			AudioManager.play_background(Const.GAME_BACK_AUDIO)
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
	GameState.count_down = toggled_on


func _on_start_button_pressed() -> void:
	restart_game()


func _on_role_button_pressed() -> void:
	role_select.show()


func _on_continue_button_pressed() -> void:
	GameState.game_state = GameState.GAME_STATE_PLAYING


func _on_guide_button_pressed() -> void:
	guide.show()


func _on_exit_button_pressed() -> void:
	GameState.game_state = GameState.GAME_STATE_WELCOME
	get_tree().quit.call_deferred()


func _on_rand_button_pressed() -> void:
	# TODO rank list
	print("Rank button pressed")


func _on_difficulty_button_pressed(value: int) -> void:
	GameState.difficulty = value


func _on_stop_button_pressed():
	GameState.game_state = GameState.GAME_STATE_WELCOME
