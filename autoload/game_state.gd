extends Node

## Manage all global game states

#region Enum
enum {
	GAME_STATE_WELCOME,
	GAME_STATE_COUNTING_DOWN,
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

## Real time effective configuration, change event: [Const.REALTIME_CONFIG]
var current_config: Config = Config.new()

## Real time buff status (s)
var buff_status: Array[float] = []

## Real time score
var score: int = 0:
	set(value):
		if score != value:
			score = value
			GameEvent.data_changed.emit(Const.SCORE, value)
	get:
		return score

## Round time (ms)
var round_time: int = 0:
	set(value):
		if round_time != value:
			round_time = value
			GameEvent.data_changed.emit(Const.ROUND_TIME, value)
	get:
		return round_time
#endregion

#region Property
## Design size
var design_size: Vector2:
	get: return get_viewport().get_visible_rect().size / game_scale


## Scoring position (x axis)
var score_pos: float:
	get: return score_pos_rate * design_size.x


## The y axis position of top wall
var top_wall_pos: float:
	get: return -wall_pos_offset


## The y axis position of bottom wall
var bottom_wall_pos: float:
	get: return design_size.y + wall_pos_offset


## The difficulty config that currently works
var current_difficulty_config: Difficulty:
	get:
		return ResourceManager.get_difficulty(difficulty)


## The role resource that currently works
var role_resource: Role:
	get:
		return ResourceManager.get_role(role)


## Round time string
var round_time_str: String:
	get:
		var ms = round_time % 1000
		@warning_ignore_start("integer_division")
		var s = (round_time / 1000) % 60
		var m = (round_time / 60000) % 60
		var h = (round_time / 3600000) % 24
		var d = round_time / 86400000
		@warning_ignore_restore("integer_division")
		var parts = []
		# TODO International
		if d > 0:
			parts.append("%dd" % d)
		if h > 0:
			parts.append("%dh" % h)
		if m > 0:
			parts.append("%dm" % m)
		parts.append("%.3fs" % (s + ms * 0.001))
		return "".join(parts)


## Dificulty string
var difficulty_str: String:
	get:
		# TODO International
		match difficulty:
			Difficulty.EASY: return tr("简单")
			Difficulty.NORMAL: return tr("普通")
			_: return tr("困难")
#endregion

#region Game Settings
## The scale of game layer
var game_scale: float = 2.0:
	set(value):
		if game_scale != value:
			game_scale = value
			GameEvent.data_changed.emit(Const.GAME_SCALE, value)
	get:
		return game_scale


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


## Window size (last time)
var window_size: Vector2i = Vector2i.ZERO:
	set(value):
		if window_size != value:
			window_size = value
			var screen_size = DisplayServer.screen_get_size()
			window_size = window_size.clamp(Const.MIN_WINDOW_SIZE, screen_size)
			GameEvent.data_changed.emit(Const.WINDOW_SIZE, window_size)
	get:
		return window_size


## Scoring position ratio (from left to right)
var score_pos_rate: float = 0.3


## Wall pixel position offset (relative to top and bottom)
var wall_pos_offset: float = 30.0
#endregion


func _ready() -> void:
	role = SaveLoadManager.get_value(Const.ROLE, Role.CHICK)
	difficulty = SaveLoadManager.get_value(Const.DIFFICULTY, Difficulty.NORMAL)
	count_down = SaveLoadManager.get_value(Const.COUNT_DOWN, true)
	current_config.key = Const.REALTIME_CONFIG


func reset_runtime_state() -> void:
	current_config.copy_from(current_difficulty_config.basic_config)
	buff_status.clear()
	score = 0
	round_time = 0
