extends Node

## Control all audio sounds
const KEY_AUDIO_MANAGER = &"AudioManager"

## Is all sounds mute
var mute: bool = false:
	set(value):
		if mute != value:
			Logger.info("Set mute: %s" % mute, KEY_AUDIO_MANAGER)
			mute = value
			GameEvent.data_changed.emit(Const.MUTE, value)
			# TODO change audio player mute
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
	get:
		return volume


func _ready() -> void:
	await get_tree().root.ready
	mute = SaveLoadManager.get_value(Const.MUTE, false)
	volume = SaveLoadManager.get_value(Const.VOLUME, 0.5)
