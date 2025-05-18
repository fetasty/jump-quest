extends Node

## Manage all global game states

#region Enum
enum {
	GAME_STATE_WELCOME,
	GAME_STATE_PLAYING,
	GAME_STATE_PAUSED,
	GAME_STATE_GAME_OVER,
}

enum {
	DIFFICULTY_EASY,
	DIFFICULTY_NORMAL,
	DIFFICULTY_HARD,
}
#endregion

#region Runtime game states
## The current game play state
var game_state: int = GAME_STATE_WELCOME:
	set(value):
		if game_state != value:
			game_state = value
			GameEvent.data_changed.emit(Const.GAME_STATE, value)
	get:
		return game_state
#endregion

#region Game Settings


## The role that currently works
var role: int = Role.CHICK:
	set(value):
		if role != value:
			role = value
			GameEvent.data_changed.emit(Const.ROLE, value)
	get:
		return role


## The difficulty that currently works
var difficulty: int = DIFFICULTY_NORMAL:
	set(value):
		if difficulty != value:
			difficulty = value
			GameEvent.data_changed.emit(Const.DIFFICULTY, value)
	get:
		return difficulty
#endregion


func _ready() -> void:
	await get_tree().root.ready
	role = SaveLoadManager.get_value(Const.ROLE, Role.CHICK)
	difficulty = SaveLoadManager.get_value(Const.DIFFICULTY, DIFFICULTY_NORMAL)
