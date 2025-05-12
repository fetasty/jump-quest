extends Node

## Manage all global game states

## Game play state

enum {
	GAME_STATE_WELCOME,
	GAME_STATE_PLAYING,
	GAME_STATE_PAUSED,
	GAME_STATE_GAME_OVER,
}

#region Runtime game states
var game_state: int = GAME_STATE_WELCOME:
	set(value):
		if game_state != value:
			game_state = value
			GameEvent.data_changed.emit(Const.GAME_STATE, value)
	get:
		return game_state
#endregion

#region Game Settings

#endregion
