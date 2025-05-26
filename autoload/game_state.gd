extends Node

## Manage all global game states

#region Enum
enum {
	GAME_STATE_WELCOME,
	GAME_STATE_PLAYING,
	GAME_STATE_PAUSED,
	GAME_STATE_GAME_OVER,
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


## Real time effective configuration
var current_config: Config = Config.new()
#endregion

#region Property
## The difficulty config that currently works
var current_difficulty_config: Difficulty:
	get:
		return ResourceManager.get_difficulty(difficulty)
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


## The difficulty id that currently works
var difficulty: int = Difficulty.NORMAL:
	set(value):
		if difficulty != value:
			difficulty = value
			GameEvent.data_changed.emit(Const.DIFFICULTY, value)
	get:
		return difficulty


## Should count down before starting game
var count_down: bool = true:
	set(value):
		if count_down != value:
			count_down = value
			GameEvent.data_changed.emit(Const.COUNT_DOWN, value)
	get:
		return count_down
#endregion


func _ready() -> void:
	role = SaveLoadManager.get_value(Const.ROLE, Role.CHICK)
	difficulty = SaveLoadManager.get_value(Const.DIFFICULTY, Difficulty.NORMAL)
	count_down = SaveLoadManager.get_value(Const.COUNT_DOWN, true)
	current_config.key = Const.REALTIME_CONFIG
	current_config.copy_from(current_difficulty_config.basic_config)


func reset_runtime_state() -> void:
	current_config.copy_from(current_difficulty_config.basic_config)
