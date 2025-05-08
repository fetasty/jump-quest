extends Node

## Manage all global game states
const KEY_GAME_STATE = &"game_state"

signal data_changed(key: StringName, value: Variant)

## Game play state
var game_state: int = GAME_STATE_WELCOME:
	set(value):
		if game_state != value:
			game_state = value
			data_changed.emit(KEY_GAME_STATE, value)
	get:
		return game_state

enum {
	GAME_STATE_WELCOME,
	GAME_STATE_PLAYING,
	GAME_STATE_PAUSED,
	GAME_STATE_GAME_OVER,
}
