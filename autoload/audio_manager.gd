extends Node

## Control all audio sounds
const KEY_AUDIO_MANAGER = &"AudioManager"
const KEY_MUTE = &"mute"
const KEY_VOLUME = &"volume"

signal data_changed(key: StringName, value: Variant)

## Is all sounds mute
var mute: bool = false:
	set(value):
		if mute != value:
			Logger.info("Set mute: %s" % mute, KEY_AUDIO_MANAGER)
			mute = value
			data_changed.emit(KEY_MUTE, value)
			# TODO change audio player mute
	get:
		return mute

## Sounds volume
var volume: float = 0.5:
	set(value):
		if not is_equal_approx(value, volume):
			Logger.info("Set volume: %s" % value, KEY_AUDIO_MANAGER)
			volume = value
			data_changed.emit(KEY_VOLUME, value)
			# TODO change audio player volume
	get:
		return volume


func _ready() -> void:
	await get_tree().root.ready
	mute = SaveLoadManager.get_value(KEY_MUTE, false)
	volume = SaveLoadManager.get_value(KEY_VOLUME, 0.5)
