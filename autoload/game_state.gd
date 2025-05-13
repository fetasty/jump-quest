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
	ROLE_CHICK = 0,
	ROLE_DOG = 1,
	ROLE_PIG = 2,
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
var role: int = ROLE_CHICK:
	set(value):
		if role != value:
			role = value
			GameEvent.data_changed.emit(Const.ROLE, value)
	get:
		return role
#endregion


func _ready() -> void:
	await get_tree().root.ready
	role = SaveLoadManager.get_value(Const.ROLE, ROLE_CHICK)
