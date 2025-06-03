extends Node2D

const BARRIER = preload("res://game/barrier.tscn")

@onready var barriers: Node2D = %Barriers
@onready var barrier_spawn_timer: Timer = %BarrierSpawnTimer
@onready var player: Player = %Player
@onready var barrier_generate_timer: Timer = %BarrierGenerateTimer

var temp_barriers: Array = []

func _ready() -> void:
	GameState.reset_runtime_state()
	player.position = GameState.design_size * 0.5
	player.collided.connect(on_player_collided)
	load_data()
	GameEvent.data_changed.connect(on_data_changed)
	barrier_generate_timer.start(GameState.current_config.barrier_spawn_interval)
	generate_barrier()


func _physics_process(delta: float) -> void:
	GameState.round_time += int(delta * 1000)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		GameState.game_state = GameState.GAME_STATE_PAUSED


func load_data() -> void:
	on_game_state_changed(GameState.game_state)


func generate_barrier() -> void:
	var barrier = null
	if not temp_barriers.is_empty():
		# TODO test
		Logger.debug("Temp barriers size: %s, pop barrier from temp array" % temp_barriers.size)
		barrier = temp_barriers.pop_back()
	else:
		barrier = BARRIER.instantiate()
	if not barrier.score_pos_reached.is_connected(on_barrier_reached_score_pos):
		barrier.score_pos_reached.connect(on_barrier_reached_score_pos)
	if not barrier.exited_viewport.is_connected(on_barrier_exited_viewport):
		barrier.exited_viewport.connect(on_barrier_exited_viewport)
	barriers.add_child(barrier)


func on_game_state_changed(state: int) -> void:
	match state:
		GameState.GAME_STATE_PLAYING:
			process_mode = Node.PROCESS_MODE_INHERIT
		GameState.GAME_STATE_PAUSED:
			process_mode = Node.PROCESS_MODE_DISABLED
		_: pass


func on_data_changed(key: String, value: Variant) -> void:
	match key:
		Const.GAME_STATE:
			on_game_state_changed(value)
		Const.REALTIME_CONFIG:
			barrier_generate_timer.wait_time = value.barrier_spawn_interval
		_: pass


func _on_barrier_generate_timer_timeout() -> void:
	generate_barrier()


func on_barrier_reached_score_pos() -> void:
	GameState.score += 1


func on_barrier_exited_viewport(barrier: Node2D) -> void:
	barriers.remove_child(barrier)
	temp_barriers.append(barrier)


func on_player_collided() -> void:
	GameState.game_state = GameState.GAME_STATE_GAME_OVER
	# TODO game record
	var record = {
		"score": GameState.score,
		"round_time": GameState.round_time,
		"difficulty": GameState.difficulty,
		"role": GameState.role,
	}
	Logger.info("Game over, record: %s" % record)
