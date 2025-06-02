extends Node2D

const BARRIER = preload("res://game/barrier.tscn")

@onready var barriers: Node2D = %Barriers
@onready var barrier_spawn_timer: Timer = %BarrierSpawnTimer
@onready var player: Player = %Player
@onready var barrier_generate_timer: Timer = %BarrierGenerateTimer


func _ready() -> void:
	GameState.reset_runtime_state()
	player.position = GameState.design_size * 0.5
	load_data()
	GameEvent.data_changed.connect(on_data_changed)
	barrier_generate_timer.start(GameState.current_config.barrier_spawn_interval)
	_on_barrier_generate_timer_timeout()


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	GameState.round_time += int(delta * 1000)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		GameState.game_state = GameState.GAME_STATE_PAUSED


func load_data() -> void:
	on_game_state_changed(GameState.game_state)


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
	pass # Replace with function body.
	var barrier = BARRIER.instantiate()
	barriers.add_child(barrier)
