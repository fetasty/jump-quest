extends Node

## Manage all global game states

signal game_state_changed(state_name: StringName, value: Variant)

enum {
	GAME_STATE_WELCOME,
	GAME_STATE_PLAYING,
	GAME_STATE_PAUSED,
	GAME_STATE_GAME_OVER,
}

const GAME_STATE = &"game_state"

## Game play state
var game_state: int = GAME_STATE_WELCOME:
	set(value):
		if game_state != value:
			game_state = value
			game_state_changed.emit(GAME_STATE, value)
	get:
		return game_state
