extends Node

signal background_finished

## Control all audio sounds
const KEY_AUDIO_MANAGER = &"AudioManager"
const MAX_SOUND_PLAYER_COUNT = 10

var audios: Node

var background_audio_player: AudioStreamPlayer
var current_background_audio: String = ""
var sound_player_active_arr: Array[AudioStreamPlayer] = []
var sound_player_idle_arr: Array[AudioStreamPlayer] = []

## Is all sounds mute
var mute: bool = false:
	set(value):
		if mute != value:
			Logger.info("Set mute: %s" % mute, KEY_AUDIO_MANAGER)
			mute = value
			GameEvent.data_changed.emit(Const.MUTE, value)
			# TODO change audio player mute
			if mute:
				background_audio_player.volume_linear = 0
				for sound_player in sound_player_active_arr:
					sound_player.volume_linear = 0
				for sound_player in sound_player_idle_arr:
					sound_player.volume_linear = 0
			else:
				background_audio_player.volume_linear = volume
				for sound_player in sound_player_active_arr:
					sound_player.volume_linear = volume
				for sound_player in sound_player_idle_arr:
					sound_player.volume_linear = volume
	get:
		return mute

## Sounds volume
var volume: float = 0.5:
	set(value):
		if not is_equal_approx(value, volume):
			Logger.info("Set volume: %s" % value, KEY_AUDIO_MANAGER)
			volume = value
			GameEvent.data_changed.emit(Const.VOLUME, value)
			# TODO change audio player volume
			if value < 0.01:
				mute = true
			else:
				if mute:
					mute = false
				else:
					background_audio_player.volume_linear = volume
					for sound_player in sound_player_active_arr:
						sound_player.volume_linear = volume
					for sound_player in sound_player_idle_arr:
						sound_player.volume_linear = volume
	get:
		return volume


func _ready() -> void:
	audios = get_node("/root/Main/Audios")
	background_audio_player = AudioStreamPlayer.new()
	audios.add_child(background_audio_player)
	volume = SaveLoadManager.get_value(Const.VOLUME, 0.5)
	mute = SaveLoadManager.get_value(Const.MUTE, false)


func play_background(audio_path: String) -> void:
	if current_background_audio == audio_path:
		return
	var stream = ResourceLoader.load(audio_path) as AudioStream
	background_audio_player.stream = stream
	background_audio_player.play()


func stop_background() -> void:
	background_audio_player.stop()


func get_sound_player() -> AudioStreamPlayer:
	if sound_player_idle_arr.size() > 0:
		var sound_player = sound_player_idle_arr.pop_back()
		return sound_player
	if sound_player_active_arr.size() + sound_player_idle_arr.size() < MAX_SOUND_PLAYER_COUNT:
		var sound_player = AudioStreamPlayer.new()
		sound_player.finished.connect(on_player_finished.bind(sound_player))
		return sound_player
	return null


func play_sound(audio_path: String) -> void:
	var sound_player = get_sound_player()
	if sound_player == null:
		Logger.warn("No more sound players available, skipping sound: %s" % audio_path)
		return
	audios.add_child(sound_player)
	sound_player_active_arr.push_back(sound_player)
	var stream = ResourceLoader.load(audio_path) as AudioStream
	sound_player.stream = stream
	sound_player.play()


func on_player_finished(player: AudioStreamPlayer) -> void:
	sound_player_active_arr.erase(player)
	sound_player_idle_arr.push_back(player)
	audios.remove_child(player)


func on_background_player_finished() -> void:
	background_finished.emit()
