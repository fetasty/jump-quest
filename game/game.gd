extends Node2D

@onready var barriers: Node2D = %Barriers
@onready var barrier_spawn_timer: Timer = %BarrierSpawnTimer
@onready var player: Player = %Player


func _ready() -> void:
	GameState.reset_runtime_state()
	var design_size = get_viewport_rect().size
	player.position = design_size * 0.5
	load_data()
	GameEvent.data_changed.connect(on_data_changed)


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	GameState.round_time += int(delta * 1000)


func load_data() -> void:
	on_game_state_changed(GameState.game_state)


func on_game_state_changed(state: int) -> void:
	match state:
		GameState.GAME_STATE_PLAYING:
			pass
		GameState.GAME_STATE_PAUSED:
			pass
		_: pass


func on_data_changed(key: String, value: Variant) -> void:
	match key:
		Const.GAME_STATE:
			on_game_state_changed(value)
		_: pass
