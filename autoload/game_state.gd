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

## Real time buff status (s) [buff_id, buff_time]
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
		return Tools.time_interval_to_string(round_time)


## Dificulty string
var difficulty_str: String:
	get:
		return Tools.difficulty_to_str(difficulty)
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
var score_pos_rate: float = 0.4


## Wall pixel position offset (relative to top and bottom)
var wall_pos_offset: float = 30.0
#endregion

#region datas
## All game records, sorted by score
var records: Array
#endregion

func _ready() -> void:
	role = SaveLoadManager.get_value(Const.ROLE, Role.CHICK)
	difficulty = SaveLoadManager.get_value(Const.DIFFICULTY, Difficulty.NORMAL)
	count_down = SaveLoadManager.get_value(Const.COUNT_DOWN, true)
	records = SaveLoadManager.get_value(Const.RECORDS, []).duplicate()
	# TODO
	Logger.info("load records: %s" % [records])
	records.sort_custom(record_sort_descending)
	current_config.key = Const.REALTIME_CONFIG
	GameEvent.game_started.connect(on_game_started)


func add_record(record: Dictionary) -> void:
	records.append(record)
	records.sort_custom(record_sort_descending)
	# TODO
	Logger.info("save records: %s" % [records])
	GameEvent.data_changed.emit(Const.RECORDS, records.duplicate())


func record_sort_descending(a: Dictionary, b: Dictionary) -> int:
	if a["score"] != b["score"]:
		return a["score"] > b["score"]
	return a["record_datetime"] > b["record_datetime"]


func reset_runtime_state() -> void:
	current_config.copy_from(current_difficulty_config.basic_config)
	buff_status.clear()
	for i in range(0, Buff.BUFF_COUNT):
		buff_status.append(0.0)
	score = 0
	round_time = 0


func apply_buff(id: int, time: float) -> void:
	if id < buff_status.size():
		if is_zero_approx(buff_status[id]) and time > 0.0:
			GameEvent.data_changed.emit(Const.ADD_BUFF, { "id": id, "time": time })
		buff_status[id] = time
		GameEvent.data_changed.emit(Const.BUFF_TIME, { "id": id, "time": buff_status[id] })


func buff_status_process(delta: float) -> void:
	for i in range(buff_status.size()):
		var remove_buff: bool = false
		if buff_status[i] > 0.0:
			buff_status[i] -= delta
			if buff_status[i] <= 0.0:
				buff_status[i] = 0.0
				remove_buff = true
			GameEvent.data_changed.emit(Const.BUFF_TIME, { "id": i, "time": buff_status[i] })
			if remove_buff:
				GameEvent.data_changed.emit(Const.REMOVE_BUFF, { "id": i })


func exist_buff(buff_id: int) -> bool:
	return buff_status[buff_id] > 0.0


func add_score(value: int) -> void:
	var factor = 1
	if exist_buff(Buff.BUFF_DOUBLE):
		factor = 2
	var add_value = value * factor
	score += add_value
	GameEvent.score_added.emit(add_value)


func on_game_started() -> void:
	reset_runtime_state()
