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
## Should count down before starting game
var count_down: bool = true:
	set(value):
		if count_down != value:
			count_down = value
			GameEvent.data_changed.emit(Const.COUNT_DOWN, value)
	get:
		return count_down

## Should show guide after launch game
var show_guide: bool = true:
	set(value):
		if show_guide != value:
			show_guide = value
			GameEvent.data_changed.emit(Const.SHOW_GUIDE, value)
	get:
		return show_guide
#endregion
